# Split a document into RAG-ready chunks

Apply a Docling chunker to a converted document and return the chunks as
a tidy tibble. The default `"hybrid"` chunker produces
tokenization-aware, context-enriched chunks well suited to embedding and
retrieval pipelines; the `"hierarchical"` chunker follows the document's
structural hierarchy without a token budget.

## Usage

``` r
docling_chunk(
  x,
  chunker = c("hybrid", "hierarchical"),
  tokenizer = NULL,
  max_tokens = NULL,
  contextualize = TRUE,
  ...
)
```

## Arguments

- x:

  A `docling_document` from
  [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md).

- chunker:

  Either `"hybrid"` (default) or `"hierarchical"`.

- tokenizer:

  Hugging Face model id whose tokenizer is used to count tokens (hybrid
  chunker only). Defaults to a small sentence-embedding tokenizer when
  `max_tokens` is set; `NULL` uses Docling's built-in default.

- max_tokens:

  Optional integer token budget per chunk (hybrid chunker only). When
  `NULL`, the tokenizer's own maximum is used.

- contextualize:

  When `TRUE` (default), each chunk's `text` is enriched with
  surrounding headings and table context via the chunker's
  `contextualize()` method — the form you typically embed. The raw text
  is always also returned in `raw_text`.

- ...:

  Additional keyword arguments forwarded to the Python chunker
  constructor (for example `merge_peers` or `repeat_table_header`).

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with one row per chunk and columns:

- `chunk_id` — 1-based index.

- `text` — contextualized text (or raw text if `contextualize = FALSE`).

- `raw_text` — the chunk's unmodified text.

- `n_chars` — number of characters in `text`.

- `headings` — list-column of heading paths for the chunk.

- `pages` — list-column of integer page numbers the chunk spans.

- `n_doc_items` — number of underlying document items in the chunk.

- `doc_items` — list-column of provenance tibbles, one row per document
  item occurrence, with columns `self_ref`, `label`, `page`,
  `char_start` and `char_end`. The character span locates the occurrence
  within the originating item's text, 1-based and inclusive (ready for
  [`substr()`](https://rdrr.io/r/base/substr.html)). Spans and pages
  come from layout analysis, so they are `NA` for formats without
  provenance (e.g. 'Markdown' sources).

## Details

The hybrid chunker is token-aware: it packs content up to a token budget
and splits oversized passages. Control this with `tokenizer` (the model
whose tokenizer defines "a token") and `max_tokens` (the budget). These
are ignored by the hierarchical chunker.

## See also

[`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md),
[`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md)

## Examples

``` r
if (FALSE) { # \dontrun{
doc <- docling_convert("paper.pdf")
chunks <- docling_chunk(doc, max_tokens = 512)
chunks$text[1]

# Match your embedding model's tokenizer
docling_chunk(doc, tokenizer = "BAAI/bge-small-en-v1.5", max_tokens = 512)
} # }
```
