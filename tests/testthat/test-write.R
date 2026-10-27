test_that("docling_write_chunks validates its arguments", {
  expect_error(docling_write_chunks(1:3, "x.parquet"), "data frame")
  expect_error(docling_write_chunks(data.frame(x = 1), c("a", "b")), "single file path")
})

test_that("docling_write_chunks rejects unknown extensions", {
  skip_if_not_installed("arrow")
  expect_error(
    docling_write_chunks(data.frame(x = 1), tempfile(fileext = ".csv")),
    "Unsupported extension"
  )
})

test_that("chunk tibbles round-trip through Parquet and Feather", {
  skip_if_not_installed("arrow")

  chunks <- tibble::tibble(
    chunk_id = 1:2,
    text = c("alpha", "beta"),
    raw_text = c("alpha", "beta"),
    n_chars = c(5L, 4L),
    headings = list(character(0), "Intro"),
    pages = list(1L, c(1L, 2L)),
    n_doc_items = c(1L, 2L),
    doc_items = list(
      empty_doc_items(),
      tibble::tibble(
        self_ref = "#/texts/1", label = "text", page = 1L,
        char_start = 1L, char_end = 4L
      )
    ),
    embedding = list(c(0.1, 0.2), c(0.3, 0.4)),
    n_dim = c(2L, 2L)
  )

  for (ext in c(".parquet", ".feather")) {
    path <- tempfile(fileext = ext)
    expect_identical(docling_write_chunks(chunks, path), path)
    back <- if (ext == ".parquet") {
      arrow::read_parquet(path)
    } else {
      arrow::read_feather(path)
    }
    expect_equal(nrow(back), 2L)
    expect_named(back, names(chunks))
    expect_equal(back$text, chunks$text)
    expect_equal(as.numeric(back$embedding[[2]]), c(0.3, 0.4))
    expect_equal(as.data.frame(back$doc_items[[2]]),
                 as.data.frame(chunks$doc_items[[2]]))
    unlink(path)
  }
})
