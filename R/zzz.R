# Internal package environment holding lazily-imported Python module handles.
.doclingr <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  # Configure the active Python environment for this package (no-op if none).
  reticulate::configure_environment(pkgname)
}

#' Import (and cache) a Python module, asserting the Docling backend exists
#'
#' All Python access in the package flows through this helper so that a missing
#' backend surfaces a single actionable error pointing at [install_docling()].
#'
#' @param full Fully-qualified module name, e.g. `"docling.document_converter"`
#'   or `"docling_core.transforms.chunker.tokenizer.huggingface"`.
#' @return The imported Python module (cached after first import).
#' @noRd
py_import <- function(full) {
  cached <- .doclingr[[full]]
  if (!is.null(cached)) {
    return(cached)
  }

  if (!reticulate::py_module_available("docling")) {
    cli::cli_abort(
      c(
        "The {.pkg docling} Python package is not available.",
        "i" = "Install it once with {.run doclingr::install_docling()}.",
        "i" = "Then restart your R session."
      ),
      class = "doclingr_no_docling"
    )
  }

  mod <- reticulate::import(full, delay_load = FALSE)
  assign(full, mod, envir = .doclingr)
  mod
}

#' Access a Docling Python submodule
#'
#' Thin wrapper over `py_import()` for the `docling.*` namespace.
#'
#' @param module Name of the submodule, e.g. `"document_converter"`, or `NULL`
#'   for the top-level `docling` package.
#' @return The imported Python module.
#' @noRd
py_docling <- function(module = NULL) {
  full <- if (is.null(module)) "docling" else paste0("docling.", module)
  py_import(full)
}
