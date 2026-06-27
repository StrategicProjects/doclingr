#' Extract tables as data frames
#'
#' Pull every table detected by Docling out of a converted document and return
#' them as a list of tibbles, preserving the document order.
#'
#' @param x A `docling_document` from [docling_convert()].
#'
#' @return A list of [tibble::tibble]s, one per detected table. The list is
#'   empty if no tables were found. Each element carries a `page` attribute when
#'   Docling reports the originating page.
#' @seealso [docling_convert()]
#' @export
#' @examples
#' \dontrun{
#' doc <- docling_convert("financials.pdf")
#' tbls <- docling_tables(doc)
#' tbls[[1]]
#' }
docling_tables <- function(x) {
  check_docling_document(x)
  doc <- x$document

  py_tables <- doc$tables
  if (is.null(py_tables) || length(py_tables) == 0) {
    return(list())
  }

  lapply(py_tables, function(tbl) {
    df <- tbl$export_to_dataframe(doc)
    out <- tibble::as_tibble(df)
    page <- tryCatch(tbl$prov[[1]]$page_no, error = function(e) NULL)
    if (!is.null(page)) {
      attr(out, "page") <- as.integer(page)
    }
    out
  })
}
