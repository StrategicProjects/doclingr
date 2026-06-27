# Number of pages in a converted document

Number of pages in a converted document

## Usage

``` r
docling_n_pages(x)
```

## Arguments

- x:

  A `docling_document` from
  [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md).

## Value

An integer page count (`0` for page-less formats such as Markdown).

## Examples

``` r
if (FALSE) { # \dontrun{
docling_n_pages(docling_convert("report.pdf"))
} # }
```
