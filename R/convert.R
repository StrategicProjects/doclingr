#' Convert one or more documents with Docling
#'
#' Runs Docling's document-understanding pipeline over local file paths or URLs
#' and returns lightweight R handles around the resulting `DoclingDocument`s.
#' Each handle can be exported to Markdown or JSON ([as_markdown()],
#' [as_json()]), mined for tables ([docling_tables()]), or split into chunks
#' for RAG ([docling_chunk()]).
#'
#' Supported inputs include PDF, DOCX, PPTX, XLSX, HTML, Markdown, AsciiDoc and
#' common image formats, as determined by the installed Docling version.
#'
#' @param source A character vector of file paths and/or URLs. A single source
#'   returns one `docling_document`; multiple sources are converted in one batch
#'   and returned as a `docling_document_list`.
#' @param ocr Logical; run OCR on the document. Defaults to `TRUE`. Set to
#'   `FALSE` to skip OCR for faster conversion of born-digital documents.
#' @param table_mode Table-structure model mode, one of `"fast"` or
#'   `"accurate"` (default). `"accurate"` produces better table structure at
#'   some speed cost.
#' @param device Accelerator device for the deep-learning models: `"auto"`
#'   (default), `"cpu"`, `"cuda"`, or `"mps"`.
#' @param num_threads Optional integer number of CPU threads for the
#'   accelerator. `NULL` (default) leaves Docling's default.
#' @param ... Reserved for future pipeline options; currently ignored with a
#'   warning if supplied.
#'
#' @return For a single `source`, an object of class `docling_document` (a list
#'   with the underlying Python `document` and the original `source`). For
#'   multiple sources, a `docling_document_list`: a list of `docling_document`
#'   objects named by source.
#' @seealso [as_markdown()], [docling_tables()], [docling_chunk()]
#' @export
#' @examples
#' \dontrun{
#' doc <- docling_convert("https://arxiv.org/pdf/2408.09869")
#' as_markdown(doc)
#'
#' # Batch, OCR off, fast tables
#' docs <- docling_convert(c("a.pdf", "b.pdf"), ocr = FALSE, table_mode = "fast")
#' }
docling_convert <- function(source,
                            ocr = TRUE,
                            table_mode = c("accurate", "fast"),
                            device = c("auto", "cpu", "cuda", "mps"),
                            num_threads = NULL,
                            ...) {
  if (!is.character(source) || length(source) == 0 || anyNA(source)) {
    cli::cli_abort("{.arg source} must be a non-empty character vector of paths or URLs.")
  }
  table_mode <- rlang::arg_match(table_mode)
  device <- rlang::arg_match(device)
  if (...length() > 0) {
    cli::cli_warn("Extra arguments to {.fn docling_convert} are currently ignored.")
  }

  converter <- build_converter(
    ocr = ocr,
    table_mode = table_mode,
    device = device,
    num_threads = num_threads
  )

  if (length(source) == 1) {
    result <- converter$convert(source)
    return(new_docling_document(result$document, source))
  }

  results <- reticulate::iterate(converter$convert_all(as.list(source)))
  docs <- Map(function(res, src) new_docling_document(res$document, src),
              results, source)
  structure(stats::setNames(docs, source), class = "docling_document_list")
}

# Build a DocumentConverter, applying PDF pipeline options only when they
# diverge from Docling's defaults. Option module paths have shifted across
# Docling versions, so construction is guarded with an actionable error.
build_converter <- function(ocr, table_mode, device, num_threads) {
  defaults <- ocr && table_mode == "accurate" && device == "auto" && is.null(num_threads)
  dc <- py_docling("document_converter")
  if (defaults) {
    return(dc$DocumentConverter())
  }

  tryCatch(
    {
      base <- py_docling("datamodel.base_models")
      popts <- py_docling("datamodel.pipeline_options")

      pipeline_options <- popts$PdfPipelineOptions()
      pipeline_options$do_ocr <- ocr
      pipeline_options$table_structure_options$mode <- switch(
        table_mode,
        accurate = popts$TableFormerMode$ACCURATE,
        fast = popts$TableFormerMode$FAST
      )

      acc_args <- list(device = popts$AcceleratorDevice[[toupper(device)]])
      if (!is.null(num_threads)) {
        acc_args$num_threads <- as.integer(num_threads)
      }
      pipeline_options$accelerator_options <- do.call(popts$AcceleratorOptions, acc_args)

      fmt <- list()
      fmt[[base$InputFormat$PDF]] <- dc$PdfFormatOption(pipeline_options = pipeline_options)
      dc$DocumentConverter(format_options = fmt)
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "Could not apply pipeline options with the installed Docling version.",
          "i" = "Re-run with defaults, or open an issue with your Docling version.",
          "x" = conditionMessage(e)
        ),
        class = "doclingr_pipeline_options"
      )
    }
  )
}

new_docling_document <- function(document, source) {
  structure(
    list(document = document, source = source),
    class = "docling_document"
  )
}

#' @export
print.docling_document <- function(x, ...) {
  cli::cli_text("{.cls docling_document}")
  cli::cli_text("{.field source}: {.val {x$source}}")
  n_tables <- tryCatch(length(x$document$tables), error = function(e) NA_integer_)
  if (!is.na(n_tables)) {
    cli::cli_text("{.field tables}: {n_tables}")
  }
  invisible(x)
}

#' @export
format.docling_document <- function(x, ...) {
  paste0("<docling_document: ", x$source, ">")
}

#' @export
print.docling_document_list <- function(x, ...) {
  cli::cli_text("{.cls docling_document_list} of {length(x)} document{?s}")
  for (nm in names(x)) {
    cli::cli_li("{.val {nm}}")
  }
  invisible(x)
}

is_docling_document <- function(x) {
  inherits(x, "docling_document")
}

check_docling_document <- function(x, arg = rlang::caller_arg(x)) {
  if (!is_docling_document(x)) {
    cli::cli_abort("{.arg {arg}} must be a {.cls docling_document} from {.fn docling_convert}.")
  }
  invisible(x)
}
