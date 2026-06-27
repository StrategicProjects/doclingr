test_that("empty_chunks has the documented shape", {
  ec <- empty_chunks()
  expect_s3_class(ec, "tbl_df")
  expect_named(ec, c("chunk_id", "text", "raw_text", "n_chars", "headings",
                     "pages", "n_doc_items"))
  expect_equal(nrow(ec), 0L)
})

test_that("normalize_embeddings accepts matrices and lists", {
  m <- matrix(1:6, nrow = 3)
  expect_length(normalize_embeddings(m, 3), 3)
  expect_equal(normalize_embeddings(m, 3)[[1]], as.numeric(m[1, ]))

  l <- list(c(1, 2), c(3, 4))
  expect_length(normalize_embeddings(l, 2), 2)

  expect_length(normalize_embeddings(c(1, 2, 3), 1), 1)
})

test_that("normalize_embeddings validates counts and types", {
  expect_error(normalize_embeddings(matrix(1:4, nrow = 2), 3), "row")
  expect_error(normalize_embeddings(list(1, 2, 3), 2), "vector")
  expect_error(normalize_embeddings("nope", 2), "numeric matrix")
})

test_that("docling_embed validates its arguments", {
  df <- data.frame(text = c("a", "b"), stringsAsFactors = FALSE)
  expect_error(docling_embed(1:3, identity), "data frame")
  expect_error(docling_embed(df, "notafun"), "function")
  expect_error(docling_embed(df, identity, text_column = "missing"), "not found")
})

test_that("docling_embed attaches an embedding list-column", {
  df <- data.frame(text = c("a", "b", "c"), stringsAsFactors = FALSE)
  embedder <- function(txt) matrix(seq_len(length(txt) * 4), nrow = length(txt))
  out <- docling_embed(df, embedder)
  expect_true(all(c("embedding", "n_dim") %in% names(out)))
  expect_length(out$embedding, 3)
  expect_equal(out$n_dim, c(4L, 4L, 4L))
})

test_that("docling_embed batches without changing the result", {
  df <- data.frame(text = as.character(1:5), stringsAsFactors = FALSE)
  embedder <- function(txt) matrix(rep(nchar(txt), 3), ncol = 3)
  whole <- docling_embed(df, embedder)
  batched <- docling_embed(df, embedder, batch_size = 2)
  expect_equal(whole$embedding, batched$embedding)
})

test_that("hybrid tokenizer control works end to end", {
  skip_if_not(docling_available(), "docling Python package not available")
  src <- system.file("examples", "sample.md", package = "doclingr")
  skip_if(src == "", "sample document missing")

  doc <- docling_convert(src)
  chunks <- docling_chunk(doc, max_tokens = 128)
  expect_s3_class(chunks, "tbl_df")
  expect_true(all(c("pages", "n_doc_items") %in% names(chunks)))
  expect_type(chunks$pages, "list")
})
