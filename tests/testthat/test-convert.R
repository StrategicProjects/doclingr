# Most tests require the Docling Python backend; they self-skip when it is
# unavailable so the suite still runs on CI without a heavyweight Python env.
skip_if_no_docling <- function() {
  testthat::skip_if_not(docling_available(), "docling Python package not available")
}

test_that("docling_convert validates its input", {
  expect_error(docling_convert(123), "character vector")
  expect_error(docling_convert(character(0)), "non-empty")
  expect_error(docling_convert(NA_character_), "character vector")
})

test_that("check_docling_document rejects foreign objects", {
  expect_error(as_markdown(structure(list(), class = "foo")))
  expect_error(docling_tables(1:10))
})

test_that("docling_available returns a logical scalar", {
  res <- docling_available()
  expect_type(res, "logical")
  expect_length(res, 1)
})

test_that("empty_chunks has the documented shape", {
  ec <- empty_chunks()
  expect_s3_class(ec, "tbl_df")
  expect_named(ec, c("chunk_id", "text", "raw_text", "n_chars", "headings"))
  expect_equal(nrow(ec), 0L)
})

test_that("round-trip conversion works when docling is installed", {
  skip_if_no_docling()
  src <- system.file("examples", "sample.md", package = "doclingr")
  skip_if(src == "", "sample document missing")

  doc <- docling_convert(src)
  expect_s3_class(doc, "docling_document")
  expect_type(as_markdown(doc), "character")
  expect_type(as_json(doc), "list")

  tbls <- docling_tables(doc)
  expect_type(tbls, "list")
  expect_s3_class(tbls[[1]], "tbl_df")

  chunks <- docling_chunk(doc)
  expect_s3_class(chunks, "tbl_df")
  expect_true(all(c("chunk_id", "text", "raw_text", "headings") %in% names(chunks)))
})

test_that("batch conversion returns a named docling_document_list", {
  skip_if_no_docling()
  src <- system.file("examples", "sample.md", package = "doclingr")
  skip_if(src == "", "sample document missing")

  docs <- docling_convert(c(src, src))
  expect_s3_class(docs, "docling_document_list")
  expect_length(docs, 2)
  expect_s3_class(docs[[1]], "docling_document")
})

test_that("pipeline options build a converter", {
  skip_if_no_docling()
  conv <- build_converter(ocr = FALSE, table_mode = "fast", device = "cpu", num_threads = 2)
  expect_false(is.null(conv))
})
