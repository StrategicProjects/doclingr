# Convert one or more documents with Docling

Runs Docling's document-understanding pipeline over local file paths or
URLs and returns lightweight R handles around the resulting
`DoclingDocument`s. Each handle can be exported to Markdown or JSON
([`as_markdown()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md),
[`as_json()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)),
mined for tables
([`docling_tables()`](https://strategicprojects.github.io/doclingr/reference/docling_tables.md)),
or split into chunks for RAG
([`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)).

## Usage

``` r
docling_convert(
  source,
  ocr = TRUE,
  table_mode = c("accurate", "fast"),
  device = c("auto", "cpu", "cuda", "mps"),
  num_threads = NULL,
  images = FALSE,
  images_scale = 1,
  ...
)
```

## Arguments

- source:

  A character vector of file paths and/or URLs. A single source returns
  one `docling_document`; multiple sources are converted in one batch
  and returned as a `docling_document_list`.

- ocr:

  Logical; run OCR on the document. Defaults to `TRUE`. Set to `FALSE`
  to skip OCR for faster conversion of born-digital documents.

- table_mode:

  Table-structure model mode, one of `"fast"` or `"accurate"` (default).
  `"accurate"` produces better table structure at some speed cost.

- device:

  Accelerator device for the deep-learning models: `"auto"` (default),
  `"cpu"`, `"cuda"`, or `"mps"`.

- num_threads:

  Optional integer number of CPU threads for the accelerator. `NULL`
  (default) leaves Docling's default.

- images:

  Logical; generate and retain page and picture images so they can be
  saved later with
  [`docling_figures()`](https://strategicprojects.github.io/doclingr/reference/docling_figures.md).
  Defaults to `FALSE` (smaller, faster results). Required if you want
  image files out.

- images_scale:

  Image resolution scale relative to 72 DPI when `images` is `TRUE` (for
  example `2` is approx. 144 DPI). Defaults to `1`.

- ...:

  Reserved for future pipeline options; currently ignored with a warning
  if supplied.

## Value

For a single `source`, an object of class `docling_document` (a list
with the underlying Python `document` and the original `source`). For
multiple sources, a `docling_document_list`: a list of
`docling_document` objects named by source.

## Details

Supported inputs include PDF, DOCX, PPTX, XLSX, HTML, Markdown, AsciiDoc
and common image formats, as determined by the installed Docling
version.

## See also

[`as_markdown()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md),
[`docling_tables()`](https://strategicprojects.github.io/doclingr/reference/docling_tables.md),
[`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)

## Examples

``` r
if (FALSE) { # \dontrun{
doc <- docling_convert("https://arxiv.org/pdf/2408.09869")
as_markdown(doc)

# Batch, OCR off, fast tables
docs <- docling_convert(c("a.pdf", "b.pdf"), ocr = FALSE, table_mode = "fast")
} # }
```
