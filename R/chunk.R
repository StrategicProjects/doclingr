# Default tokenizer used when the caller asks for a token budget or names no
# model. A small, widely-used sentence-embedding tokenizer.
default_chunk_tokenizer <- "sentence-transformers/all-MiniLM-L6-v2"

#' Split a document into RAG-ready chunks
#'
#' Apply a Docling chunker to a converted document and return the chunks as a
#' tidy tibble. The default `"hybrid"` chunker produces tokenization-aware,
#' context-enriched chunks well suited to embedding and retrieval pipelines; the
#' `"hierarchical"` chunker follows the document's structural hierarchy without
#' a token budget.
#'
#' The hybrid chunker is token-aware: it packs content up to a token budget and
#' splits oversized passages. Control this with `tokenizer` (the model whose
#' tokenizer defines "a token") and `max_tokens` (the budget). These are ignored
#' by the hierarchical chunker.
#'
#' @param x A `docling_document` from [docling_convert()].
#' @param chunker Either `"hybrid"` (default) or `"hierarchical"`.
#' @param tokenizer Hugging Face model id whose tokenizer is used to count
#'   tokens (hybrid chunker only). Defaults to a small sentence-embedding
#'   tokenizer when `max_tokens` is set; `NULL` uses Docling's built-in default.
#' @param max_tokens Optional integer token budget per chunk (hybrid chunker
#'   only). When `NULL`, the tokenizer's own maximum is used.
#' @param contextualize When `TRUE` (default), each chunk's `text` is enriched
#'   with surrounding headings and table context via the chunker's
#'   `contextualize()` method — the form you typically embed. The raw text is
#'   always also returned in `raw_text`.
#' @param ... Additional keyword arguments forwarded to the Python chunker
#'   constructor (for example `merge_peers` or `repeat_table_header`).
#'
#' @return A [tibble::tibble] with one row per chunk and columns:
#'   * `chunk_id` — 1-based index.
#'   * `text` — contextualized text (or raw text if `contextualize = FALSE`).
#'   * `raw_text` — the chunk's unmodified text.
#'   * `n_chars` — number of characters in `text`.
#'   * `headings` — list-column of heading paths for the chunk.
#'   * `pages` — list-column of integer page numbers the chunk spans.
#'   * `n_doc_items` — number of underlying document items in the chunk.
#' @seealso [docling_convert()], [docling_embed()]
#' @export
#' @examples
#' \dontrun{
#' doc <- docling_convert("paper.pdf")
#' chunks <- docling_chunk(doc, max_tokens = 512)
#' chunks$text[1]
#'
#' # Match your embedding model's tokenizer
#' docling_chunk(doc, tokenizer = "BAAI/bge-small-en-v1.5", max_tokens = 512)
#' }
docling_chunk <- function(x,
                          chunker = c("hybrid", "hierarchical"),
                          tokenizer = NULL,
                          max_tokens = NULL,
                          contextualize = TRUE,
                          ...) {
  check_docling_document(x)
  chunker <- rlang::arg_match(chunker)

  mod <- py_docling("chunking")
  ctor_args <- list(...)

  if (chunker == "hybrid") {
    tok <- build_tokenizer(tokenizer, max_tokens)
    if (!is.null(tok)) {
      ctor_args$tokenizer <- tok
    }
    engine <- do.call(mod$HybridChunker, ctor_args)
  } else {
    if (!is.null(tokenizer) || !is.null(max_tokens)) {
      cli::cli_warn("{.arg tokenizer}/{.arg max_tokens} apply only to the hybrid chunker; ignoring.")
    }
    engine <- do.call(mod$HierarchicalChunker, ctor_args)
  }

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

  tibble::tibble(
    chunk_id = seq_along(chunks),
    text = text,
    raw_text = raw_text,
    n_chars = nchar(text),
    headings = lapply(chunks, chunk_headings),
    pages = lapply(chunks, chunk_pages),
    n_doc_items = vapply(chunks, chunk_n_doc_items, integer(1))
  )
}

# Build a Docling tokenizer object, or NULL to let the chunker use its default.
build_tokenizer <- function(tokenizer, max_tokens) {
  if (is.null(tokenizer) && is.null(max_tokens)) {
    return(NULL)
  }
  model <- tokenizer %||% default_chunk_tokenizer
  hf <- py_import("docling_core.transforms.chunker.tokenizer.huggingface")
  args <- list(model_name = model)
  if (!is.null(max_tokens)) {
    args$max_tokens <- as.integer(max_tokens)
  }
  do.call(hf$HuggingFaceTokenizer$from_pretrained, args)
}

chunk_headings <- function(ch) {
  h <- tryCatch(ch$meta$headings, error = function(e) NULL)
  if (is.null(h)) character(0) else as.character(h)
}

chunk_pages <- function(ch) {
  items <- tryCatch(ch$meta$doc_items, error = function(e) NULL)
  if (is.null(items) || length(items) == 0) {
    return(integer(0))
  }
  pages <- unlist(lapply(items, function(it) {
    prov <- tryCatch(it$prov, error = function(e) NULL)
    if (is.null(prov)) {
      return(NULL)
    }
    vapply(prov, function(p) as.integer(p$page_no), integer(1))
  }))
  sort(unique(pages))
}

chunk_n_doc_items <- function(ch) {
  items <- tryCatch(ch$meta$doc_items, error = function(e) NULL)
  if (is.null(items)) 0L else length(items)
}

empty_chunks <- function() {
  tibble::tibble(
    chunk_id = integer(0),
    text = character(0),
    raw_text = character(0),
    n_chars = integer(0),
    headings = list(),
    pages = list(),
    n_doc_items = integer(0)
  )
}
