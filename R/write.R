#' Write chunks (and embeddings) to Parquet or Feather
#'
#' Persist a chunk tibble from [docling_chunk()] — optionally carrying the
#' `embedding` list-column added by [docling_embed()] — to a columnar file via
#' the arrow package. List-columns (`headings`, `pages`, `doc_items`,
#' `embedding`) are stored natively, so the file round-trips back to the same
#' shape with `arrow::read_parquet()` / `arrow::read_feather()` and is directly
#' queryable from 'Python', 'DuckDB', 'Spark' and other 'Arrow'-aware tools —
#' a convenient hand-off format for RAG indexing pipelines.
#'
#' @param chunks A data frame, typically from [docling_chunk()] or
#'   [docling_embed()].
#' @param path Output file path. The format is chosen by extension:
#'   `.parquet` writes 'Parquet'; `.feather` or `.arrow` write 'Feather' v2
#'   (the 'Arrow' IPC format).
#' @param ... Additional arguments passed on to [arrow::write_parquet()] or
#'   [arrow::write_feather()] (for example `compression`).
#'
#' @return `path`, invisibly.
#' @seealso [docling_chunk()], [docling_embed()]
#' @export
#' @examples
#' \dontrun{
#' doc    <- docling_convert("paper.pdf")
#' chunks <- docling_chunk(doc, max_tokens = 512)
#' docling_write_chunks(chunks, "paper-chunks.parquet")
#'
#' # Read back, or query from any Arrow-aware tool
#' arrow::read_parquet("paper-chunks.parquet")
#' }
docling_write_chunks <- function(chunks, path, ...) {
  if (!is.data.frame(chunks)) {
    cli::cli_abort("{.arg chunks} must be a data frame, not {.obj_type_friendly {chunks}}.")
  }
  if (!rlang::is_string(path)) {
    cli::cli_abort("{.arg path} must be a single file path.")
  }
  rlang::check_installed("arrow", reason = "to write chunks to Parquet/Feather.")

  ext <- tolower(tools::file_ext(path))
  switch(ext,
    parquet = arrow::write_parquet(chunks, path, ...),
    feather = ,
    arrow = arrow::write_feather(chunks, path, ...),
    cli::cli_abort(c(
      "Unsupported extension {.val {ext}} in {.arg path}.",
      i = "Use {.val .parquet}, {.val .feather} or {.val .arrow}."
    ))
  )
  invisible(path)
}
