# Write chunks (and embeddings) to Parquet or Feather

Persist a chunk tibble from
[`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)
— optionally carrying the `embedding` list-column added by
[`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md)
— to a columnar file via the arrow package. List-columns (`headings`,
`pages`, `doc_items`, `embedding`) are stored natively, so the file
round-trips back to the same shape with
[`arrow::read_parquet()`](https://arrow.apache.org/docs/r/reference/read_parquet.html)
/
[`arrow::read_feather()`](https://arrow.apache.org/docs/r/reference/read_feather.html)
and is directly queryable from 'Python', 'DuckDB', 'Spark' and other
'Arrow'-aware tools — a convenient hand-off format for RAG indexing
pipelines.

## Usage

``` r
docling_write_chunks(chunks, path, ...)
```

## Arguments

- chunks:

  A data frame, typically from
  [`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)
  or
  [`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md).

- path:

  Output file path. The format is chosen by extension: `.parquet` writes
  'Parquet'; `.feather` or `.arrow` write 'Feather' v2 (the 'Arrow' IPC
  format).

- ...:

  Additional arguments passed on to
  [`arrow::write_parquet()`](https://arrow.apache.org/docs/r/reference/write_parquet.html)
  or
  [`arrow::write_feather()`](https://arrow.apache.org/docs/r/reference/write_feather.html)
  (for example `compression`).

## Value

`path`, invisibly.

## See also

[`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md),
[`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md)

## Examples

``` r
if (FALSE) { # \dontrun{
doc    <- docling_convert("paper.pdf")
chunks <- docling_chunk(doc, max_tokens = 512)
docling_write_chunks(chunks, "paper-chunks.parquet")

# Read back, or query from any Arrow-aware tool
arrow::read_parquet("paper-chunks.parquet")
} # }
```
