# Internal package environment holding lazily-imported Python module handles.
.doclingr <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  # Configure the active Python environment for this package (no-op if none).
  reticulate::configure_environment(pkgname)
}

#' Access a Docling Python submodule
#'
#' Imports (and caches) a Docling submodule on first use. All Python access in
#' the package flows through this helper so that import failures surface a single
#' actionable error pointing users at [install_docling()].
#'
#' @param module Name of the submodule, e.g. `"document_converter"`.
#' @return The imported Python module.
#' @noRd
py_docling <- function(module = NULL) {
  full <- if (is.null(module)) "docling" else paste0("docling.", module)
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
