#' Extract figures (pictures) from a converted document
#'
#' Return a tidy tibble of the pictures Docling detected, with their captions
#' and page numbers. When `image_dir` is supplied and the document was converted
#' with `images = TRUE`, each picture is written to disk and its path returned.
#'
#' @param x A `docling_document` from [docling_convert()].
#' @param image_dir Optional directory to save picture images into. Created if
#'   it does not exist. Requires [docling_convert()] to have been called with
#'   `images = TRUE`; otherwise image data is unavailable and `image_path` is
#'   `NA` with a warning.
#' @param format Image file format when saving, for example `"png"` (default)
#'   or `"jpeg"`.
#'
#' @return A [tibble::tibble] with one row per figure and columns:
#'   * `figure_id` — 1-based index.
#'   * `caption` — caption text (empty string if none).
#'   * `page` — page number the figure appears on (`NA` if unknown).
#'   * `image_path` — path to the saved image, or `NA` if not saved.
#' @seealso [docling_convert()]
#' @export
#' @examples
#' \dontrun{
#' doc <- docling_convert("paper.pdf", images = TRUE)
#' figs <- docling_figures(doc, image_dir = "figures")
#' figs$image_path
#' }
docling_figures <- function(x, image_dir = NULL, format = "png") {
  check_docling_document(x)
  doc <- x$document

  pics <- doc$pictures
  if (is.null(pics) || length(pics) == 0) {
    return(empty_figures())
  }

  if (!is.null(image_dir) && !dir.exists(image_dir)) {
    dir.create(image_dir, recursive = TRUE)
  }
  warned_no_image <- FALSE

  rows <- lapply(seq_along(pics), function(i) {
    pic <- pics[[i]]
    caption <- tryCatch(pic$caption_text(doc), error = function(e) "")
    page <- tryCatch(as.integer(pic$prov[[1]]$page_no), error = function(e) NA_integer_)

    image_path <- NA_character_
    if (!is.null(image_dir)) {
      img <- tryCatch(pic$get_image(doc), error = function(e) NULL)
      if (is.null(img)) {
        warned_no_image <<- TRUE
      } else {
        path <- file.path(image_dir, sprintf("figure-%03d.%s", i, format))
        img$save(path)
        image_path <- path
      }
    }

    tibble::tibble(
      figure_id = i,
      caption = caption %||% "",
      page = page,
      image_path = image_path
    )
  })

  if (warned_no_image) {
    cli::cli_warn(c(
      "Some figures had no image data to save.",
      "i" = "Re-run {.fn docling_convert} with {.code images = TRUE}."
    ))
  }

  do.call(rbind, rows)
}

empty_figures <- function() {
  tibble::tibble(
    figure_id = integer(0),
    caption = character(0),
    page = integer(0),
    image_path = character(0)
  )
}
