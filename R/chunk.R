#' Split a document into RAG-ready chunks
#'
#' Apply a Docling chunker to a converted document and return the chunks as a
#' tidy tibble. The default `"hybrid"` chunker produces tokenization-aware,
#' context-enriched chunks well suited to embedding and retrieval pipelines; the
#' `"hierarchical"` chunker follows the document's structural hierarchy without
#' a token budget.
#'
#' @param x A `docling_document` from [docling_convert()].
#' @param chunker Either `"hybrid"` (default) or `"hierarchical"`.
#' @param max_tokens Optional integer token budget per chunk (hybrid chunker
#'   only). When `NULL`, Docling's default for the tokenizer is used.
#' @param contextualize When `TRUE` (default), each chunk's `text` is enriched
#'   with surrounding headings and table context via the chunker's
#'   `contextualize()` method — the form you typically embed. The raw text is
#'   always also returned in `raw_text`.
#' @param ... Additional keyword arguments forwarded to the Python chunker
#'   constructor.
#'
#' @return A [tibble::tibble] with one row per chunk and columns:
#'   * `chunk_id` — 1-based index.
#'   * `text` — contextualized text (or raw text if `contextualize = FALSE`).
#'   * `raw_text` — the chunk's unmodified text.
#'   * `n_chars` — number of characters in `text`.
#'   * `headings` — list-column of heading paths for the chunk.
#' @seealso [docling_convert()]
#' @export
#' @examples
#' \dontrun{
#' doc <- docling_convert("paper.pdf")
#' chunks <- docling_chunk(doc, max_tokens = 512)
#' chunks$text[1]
#' }
docling_chunk <- function(x,
                          chunker = c("hybrid", "hierarchical"),
                          max_tokens = NULL,
                          contextualize = TRUE,
                          ...) {
  check_docling_document(x)
  chunker <- rlang::arg_match(chunker)

  mod <- py_docling("chunking")
  ctor_args <- list(...)
  if (!is.null(max_tokens)) {
    if (chunker != "hybrid") {
      cli::cli_warn("{.arg max_tokens} is only used by the hybrid chunker; ignoring.")
    } else {
      ctor_args$max_tokens <- as.integer(max_tokens)
    }
  }

  engine <- switch(
    chunker,
    hybrid = do.call(mod$HybridChunker, ctor_args),
    hierarchical = do.call(mod$HierarchicalChunker, ctor_args)
  )

  chunks <- reticulate::iterate(engine$chunk(dl_doc = x$document))
  if (length(chunks) == 0) {
    return(empty_chunks())
  }

  raw_text <- vapply(chunks, function(ch) ch$text, character(1))
  text <- if (contextualize) {
    vapply(chunks, function(ch) engine$contextualize(chunk = ch), character(1))
  } else {
    raw_text
  }
  headings <- lapply(chunks, chunk_headings)

  tibble::tibble(
    chunk_id = seq_along(chunks),
    text = text,
    raw_text = raw_text,
    n_chars = nchar(text),
    headings = headings
  )
}

chunk_headings <- function(ch) {
  h <- tryCatch(ch$meta$headings, error = function(e) NULL)
  if (is.null(h)) character(0) else as.character(h)
}

empty_chunks <- function() {
  tibble::tibble(
    chunk_id = integer(0),
    text = character(0),
    raw_text = character(0),
    n_chars = integer(0),
    headings = list()
  )
}
