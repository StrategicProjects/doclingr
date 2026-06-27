#' Attach embeddings to chunks
#'
#' Embed a chunk tibble's text with a user-supplied embedding function and
#' return the tibble with an `embedding` list-column. doclingr stays
#' provider-agnostic: you bring the `embedder` (an OpenAI/Cohere/Ollama API
#' call, a local sentence-transformers model via reticulate, anything), and this
#' helper handles batching, validation and tidy assembly.
#'
#' @param chunks A tibble of chunks, typically from [docling_chunk()].
#' @param embedder A function taking a character vector and returning either a
#'   numeric matrix with one row per input, or a list of equal-length numeric
#'   vectors.
#' @param text_column Name of the column to embed. Defaults to `"text"`.
#' @param batch_size Optional integer; if set, `embedder` is called on
#'   successive batches of at most this many texts and the results concatenated.
#'   Useful for APIs with per-request limits. `NULL` (default) embeds in one call.
#'
#' @return `chunks` with an added `embedding` list-column of numeric vectors,
#'   and an `n_dim` integer column giving each embedding's length.
#' @seealso [docling_chunk()]
#' @export
#' @examples
#' \dontrun{
#' chunks <- docling_chunk(docling_convert("paper.pdf"), max_tokens = 512)
#'
#' # Any embedder: here a toy one
#' embed_fn <- function(txt) matrix(stats::runif(length(txt) * 8), nrow = length(txt))
#' docling_embed(chunks, embed_fn)
#' }
docling_embed <- function(chunks, embedder, text_column = "text", batch_size = NULL) {
  if (!is.data.frame(chunks)) {
    cli::cli_abort("{.arg chunks} must be a data frame, e.g. from {.fn docling_chunk}.")
  }
  if (!is.function(embedder)) {
    cli::cli_abort("{.arg embedder} must be a function of a character vector.")
  }
  if (!text_column %in% names(chunks)) {
    cli::cli_abort("Column {.val {text_column}} not found in {.arg chunks}.")
  }

  texts <- as.character(chunks[[text_column]])
  n <- length(texts)
  if (n == 0) {
    chunks$embedding <- list()
    chunks$n_dim <- integer(0)
    return(chunks)
  }

  emb <- if (is.null(batch_size)) {
    normalize_embeddings(embedder(texts), n)
  } else {
    batch_size <- as.integer(batch_size)
    if (batch_size < 1) {
      cli::cli_abort("{.arg batch_size} must be a positive integer.")
    }
    idx <- split(seq_len(n), ceiling(seq_len(n) / batch_size))
    out <- vector("list", n)
    for (g in idx) {
      out[g] <- normalize_embeddings(embedder(texts[g]), length(g))
    }
    out
  }

  dims <- vapply(emb, length, integer(1))
  if (length(unique(dims)) > 1) {
    cli::cli_warn("Embeddings have inconsistent dimensions ({.val {sort(unique(dims))}}).")
  }

  chunks$embedding <- emb
  chunks$n_dim <- dims
  chunks
}

# Coerce an embedder's output (matrix or list) into a list of `n` numeric
# vectors, validating the count.
normalize_embeddings <- function(out, n) {
  vecs <- if (is.matrix(out)) {
    if (nrow(out) != n) {
      cli::cli_abort("Embedder returned {nrow(out)} row{?s} for {n} input{?s}.")
    }
    lapply(seq_len(nrow(out)), function(i) as.numeric(out[i, ]))
  } else if (is.list(out)) {
    if (length(out) != n) {
      cli::cli_abort("Embedder returned {length(out)} vector{?s} for {n} input{?s}.")
    }
    lapply(out, as.numeric)
  } else if (is.numeric(out) && n == 1) {
    list(as.numeric(out))
  } else {
    cli::cli_abort("Embedder must return a numeric matrix or a list of numeric vectors.")
  }
  vecs
}
