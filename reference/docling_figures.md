# Extract figures (pictures) from a converted document

Return a tidy tibble of the pictures Docling detected, with their
captions and page numbers. When `image_dir` is supplied and the document
was converted with `images = TRUE`, each picture is written to disk and
its path returned.

## Usage

``` r
docling_figures(x, image_dir = NULL, format = "png")
```

## Arguments

- x:

  A `docling_document` from
  [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md).

- image_dir:

  Optional directory to save picture images into. Created if it does not
  exist. Requires
  [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)
  to have been called with `images = TRUE`; otherwise image data is
  unavailable and `image_path` is `NA` with a warning.

- format:

  Image file format when saving, for example `"png"` (default) or
  `"jpeg"`.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with one row per figure and columns:

- `figure_id` — 1-based index.

- `caption` — caption text (empty string if none).

- `page` — page number the figure appears on (`NA` if unknown).

- `image_path` — path to the saved image, or `NA` if not saved.

## See also

[`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)

## Examples

``` r
if (FALSE) { # \dontrun{
doc <- docling_convert("paper.pdf", images = TRUE)
figs <- docling_figures(doc, image_dir = "figures")
figs$image_path
} # }
```
