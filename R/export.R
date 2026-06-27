#' Export a converted document
#'
#' Render a [docling_convert()] result into a downstream-friendly format.
#'
#' @param x A `docling_document` from [docling_convert()].
#' @param ... Additional arguments passed to the underlying Docling export
#'   method (for example `image_mode` for Markdown).
#'
#' @return
#'   * `as_markdown()`: a length-1 character string of Markdown.
#'   * `as_text()`: a length-1 character string of plain text.
#'   * `as_html()`: a length-1 character string of HTML.
#'   * `as_json()`: an R list mirroring the `DoclingDocument` structure.
#'   * `as_doctags()`: a length-1 character string in Docling's DocTags format.
#'
#' @name docling_export
#' @examples
#' \dontrun{
#' doc <- docling_convert("report.pdf")
#' as_markdown(doc)
#' str(as_json(doc), max.level = 1)
#' }
NULL

#' @rdname docling_export
#' @export
as_markdown <- function(x, ...) {
  UseMethod("as_markdown")
}

#' @rdname docling_export
#' @export
as_markdown.docling_document <- function(x, ...) {
  check_docling_document(x)
  x$document$export_to_markdown(...)
}

#' @rdname docling_export
#' @export
as_text <- function(x, ...) {
  UseMethod("as_text")
}

#' @rdname docling_export
#' @export
as_text.docling_document <- function(x, ...) {
  check_docling_document(x)
  x$document$export_to_text(...)
}

#' @rdname docling_export
#' @export
as_html <- function(x, ...) {
  UseMethod("as_html")
}

#' @rdname docling_export
#' @export
as_html.docling_document <- function(x, ...) {
  check_docling_document(x)
  x$document$export_to_html(...)
}

#' @rdname docling_export
#' @export
as_json <- function(x, ...) {
  UseMethod("as_json")
}

#' @rdname docling_export
#' @export
as_json.docling_document <- function(x, ...) {
  check_docling_document(x)
  x$document$export_to_dict(...)
}

#' @rdname docling_export
#' @export
as_doctags <- function(x, ...) {
  UseMethod("as_doctags")
}

#' @rdname docling_export
#' @export
as_doctags.docling_document <- function(x, ...) {
  check_docling_document(x)
  x$document$export_to_doctags(...)
}
