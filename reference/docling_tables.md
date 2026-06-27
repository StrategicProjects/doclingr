# Extract tables as data frames

Pull every table detected by Docling out of a converted document and
return them as a list of tibbles, preserving the document order.

## Usage

``` r
docling_tables(x)
```

## Arguments

- x:

  A `docling_document` from
  [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md).

## Value

A list of
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)s,
one per detected table. The list is empty if no tables were found. Each
element carries a `page` attribute when Docling reports the originating
page.

## See also

[`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)

## Examples

``` r
if (FALSE) { # \dontrun{
doc <- docling_convert("financials.pdf")
tbls <- docling_tables(doc)
tbls[[1]]
} # }
```
