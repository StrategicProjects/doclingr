# Export a converted document

Render a
[`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)
result into a downstream-friendly format.

## Usage

``` r
as_markdown(x, ...)

# S3 method for class 'docling_document'
as_markdown(x, ...)

as_text(x, ...)

# S3 method for class 'docling_document'
as_text(x, ...)

as_html(x, ...)

# S3 method for class 'docling_document'
as_html(x, ...)

as_json(x, ...)

# S3 method for class 'docling_document'
as_json(x, ...)

as_doctags(x, ...)

# S3 method for class 'docling_document'
as_doctags(x, ...)
```

## Arguments

- x:

  A `docling_document` from
  [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md).

- ...:

  Additional arguments passed to the underlying Docling export method
  (for example `image_mode` for Markdown).

## Value

- `as_markdown()`: a length-1 character string of Markdown.

- `as_text()`: a length-1 character string of plain text.

- `as_html()`: a length-1 character string of HTML.

- `as_json()`: an R list mirroring the `DoclingDocument` structure.

- `as_doctags()`: a length-1 character string in Docling's DocTags
  format.

## Examples

``` r
if (FALSE) { # \dontrun{
doc <- docling_convert("report.pdf")
as_markdown(doc)
str(as_json(doc), max.level = 1)
} # }
```
