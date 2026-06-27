# Attach embeddings to chunks

Embed a chunk tibble's text with a user-supplied embedding function and
return the tibble with an `embedding` list-column. doclingr stays
provider-agnostic: you bring the `embedder` (an OpenAI/Cohere/Ollama API
call, a local sentence-transformers model via reticulate, anything), and
this helper handles batching, validation and tidy assembly.

## Usage

``` r
docling_embed(chunks, embedder, text_column = "text", batch_size = NULL)
```

## Arguments

- chunks:

  A tibble of chunks, typically from
  [`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md).

- embedder:

  A function taking a character vector and returning either a numeric
  matrix with one row per input, or a list of equal-length numeric
  vectors.

- text_column:

  Name of the column to embed. Defaults to `"text"`.

- batch_size:

  Optional integer; if set, `embedder` is called on successive batches
  of at most this many texts and the results concatenated. Useful for
  APIs with per-request limits. `NULL` (default) embeds in one call.

## Value

`chunks` with an added `embedding` list-column of numeric vectors, and
an `n_dim` integer column giving each embedding's length.

## See also

[`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)

## Examples

``` r
if (FALSE) { # \dontrun{
chunks <- docling_chunk(docling_convert("paper.pdf"), max_tokens = 512)

# Any embedder: here a toy one
embed_fn <- function(txt) matrix(stats::runif(length(txt) * 8), nrow = length(txt))
docling_embed(chunks, embed_fn)
} # }
```
