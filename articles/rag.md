# Building a RAG pipeline

This vignette builds a small retrieval-augmented generation (RAG) corpus
end to end: convert documents, chunk them with awareness of your
embedding model’s tokenizer, attach embeddings, and run a similarity
search.

## 1. Convert and chunk

Chunk size should respect the context window of the embedding model you
will use.
[`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)
is token-aware: point it at the *same* tokenizer as your embedder so the
`max_tokens` budget is measured in the right units.

``` r

library(doclingr)

doc <- docling_convert("paper.pdf")

chunks <- docling_chunk(
  doc,
  tokenizer  = "BAAI/bge-small-en-v1.5",
  max_tokens = 512
)
chunks
```

Each chunk’s `text` is *contextualized* – prefixed with its heading path
and table context – which is the form you should embed. The unmodified
passage is kept in `raw_text`, and `headings`/`pages` let you cite
sources later.

## 2. Attach embeddings

doclingr does not lock you into an embedding provider. You supply a
function that maps a character vector to vectors;
[`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md)
handles batching and tidy assembly. Here is a sketch against an HTTP
embeddings API:

``` r

embed_api <- function(texts) {
  # POST `texts` to your endpoint and return a matrix: one row per text.
  # e.g. with httr2:
  resp <- httr2::request("https://api.example.com/v1/embeddings") |>
    httr2::req_headers(Authorization = paste("Bearer", Sys.getenv("EMBED_KEY"))) |>
    httr2::req_body_json(list(model = "bge-small", input = texts)) |>
    httr2::req_perform()
  do.call(rbind, lapply(httr2::resp_body_json(resp)$data, \(d) unlist(d$embedding)))
}

corpus <- docling_embed(chunks, embed_api, batch_size = 64)
corpus
```

A local model works just as well – anything that returns a matrix or a
list of numeric vectors:

``` r

# Using a sentence-transformers model through reticulate
st <- reticulate::import("sentence_transformers")
model <- st$SentenceTransformer("BAAI/bge-small-en-v1.5")
embed_local <- function(texts) model$encode(texts)

corpus <- docling_embed(chunks, embed_local, batch_size = 64)
```

## 3. Retrieve

With embeddings in a matrix, retrieval is plain R. Embed the query the
same way, then rank chunks by cosine similarity:

``` r

emb <- do.call(rbind, corpus$embedding)

cosine_top <- function(query, k = 5) {
  q <- as.numeric(embed_api(query))
  sims <- as.numeric(emb %*% q) /
    (sqrt(rowSums(emb^2)) * sqrt(sum(q^2)))
  corpus[order(sims, decreasing = TRUE)[seq_len(k)], c("text", "headings", "pages")]
}

cosine_top("What datasets were used for evaluation?")
```

For larger corpora, push the embeddings into a dedicated vector store
instead of an in-memory matrix.

## 4. Persist

Converting and embedding are the expensive steps. Save the corpus so you
only pay once:

``` r

arrow::write_parquet(corpus, "corpus.parquet")
# later:
corpus <- arrow::read_parquet("corpus.parquet")
```

## Scaling to many documents

[`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)
accepts a vector of sources and converts them in one batch. Combine that
with the chunk/embed steps to build a corpus over a folder:

``` r

files <- list.files("docs", pattern = "[.](pdf|docx|html)$", full.names = TRUE)
docs  <- docling_convert(files)

corpus <- purrr::imap(docs, \(d, src) {
  docling_chunk(d, tokenizer = "BAAI/bge-small-en-v1.5", max_tokens = 512) |>
    docling_embed(embed_api, batch_size = 64) |>
    dplyr::mutate(source = src)
}) |>
  purrr::list_rbind()
```

That `corpus` – chunk text, headings, pages, source and embeddings in
one tidy table – is everything you need to power retrieval for an LLM.
