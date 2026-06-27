#' Convert a document with Docling
#'
#' Runs Docling's document-understanding pipeline over a local file path or URL
#' and returns a lightweight R handle around the resulting `DoclingDocument`.
#' The handle can be exported to Markdown or JSON ([as_markdown()],
#' [as_json()]), mined for tables ([docling_tables()]), or split into chunks
#' for RAG ([docling_chunk()]).
#'
#' Supported inputs include PDF, DOCX, PPTX, XLSX, HTML, Markdown, AsciiDoc and
#' common image formats, as determined by the installed Docling version.
#'
#' @param source A single file path or URL to convert.
#' @param ... Reserved for future pipeline options; currently ignored with a
#'   warning if supplied.
#'
#' @return An object of class `docling_document`: a list with the underlying
#'   Python `document` and the original `source`.
#' @seealso [as_markdown()], [docling_tables()], [docling_chunk()]
#' @export
#' @examples
#' \dontrun{
#' doc <- docling_convert("https://arxiv.org/pdf/2408.09869")
#' as_markdown(doc)
#' }
docling_convert <- function(source, ...) {
  if (!rlang::is_string(source)) {
    cli::cli_abort("{.arg source} must be a single string (file path or URL).")
  }
  if (...length() > 0) {
    cli::cli_warn("Extra arguments to {.fn docling_convert} are currently ignored.")
  }

  converter <- py_docling("document_converter")$DocumentConverter()
  result <- converter$convert(source)

  new_docling_document(result$document, source)
}

new_docling_document <- function(document, source) {
  structure(
    list(document = document, source = source),
    class = "docling_document"
  )
}

#' @export
print.docling_document <- function(x, ...) {
  cli::cli_text("{.cls docling_document}")
  cli::cli_text("{.field source}: {.val {x$source}}")
  n_tables <- tryCatch(length(x$document$tables), error = function(e) NA_integer_)
  if (!is.na(n_tables)) {
    cli::cli_text("{.field tables}: {n_tables}")
  }
  invisible(x)
}

#' @export
format.docling_document <- function(x, ...) {
  paste0("<docling_document: ", x$source, ">")
}

is_docling_document <- function(x) {
  inherits(x, "docling_document")
}

check_docling_document <- function(x, arg = rlang::caller_arg(x)) {
  if (!is_docling_document(x)) {
    cli::cli_abort("{.arg {arg}} must be a {.cls docling_document} from {.fn docling_convert}.")
  }
  invisible(x)
}
