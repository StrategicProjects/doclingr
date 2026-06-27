test_that("empty_figures has the documented shape", {
  ef <- empty_figures()
  expect_s3_class(ef, "tbl_df")
  expect_named(ef, c("figure_id", "caption", "page", "image_path"))
  expect_equal(nrow(ef), 0L)
})

test_that("docling_n_pages and docling_figures validate input", {
  expect_error(docling_n_pages(1:3), "docling_document")
  expect_error(docling_figures("nope"), "docling_document")
})

test_that("page and figure surfacing works with the backend", {
  skip_if_not(docling_available(), "docling Python package not available")
  src <- system.file("examples", "sample.md", package = "doclingr")
  skip_if(src == "", "sample document missing")

  doc <- docling_convert(src)
  expect_type(docling_n_pages(doc), "integer")

  figs <- docling_figures(doc)
  expect_s3_class(figs, "tbl_df")
  expect_named(figs, c("figure_id", "caption", "page", "image_path"))
})
