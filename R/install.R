#' Install the Docling Python backend
#'
#' Installs the `docling` Python package (and its dependencies) into a
#' 'reticulate'-managed environment. This is a thin wrapper around
#' [reticulate::py_install()] that you typically run once after installing
#' doclingr.
#'
#' @param envname Name of, or path to, the target Python environment. Defaults
#'   to `"r-docling"`, created on first use.
#' @param method Installation method passed to [reticulate::py_install()]:
#'   one of `"auto"`, `"virtualenv"`, or `"conda"`.
#' @param extra Optional character vector of additional pip/conda specs to
#'   install alongside Docling (for example `"docling[ocr]"` or a pinned
#'   version such as `"docling==2.0.0"`).
#' @param ... Further arguments forwarded to [reticulate::py_install()].
#'
#' @return Invisibly `NULL`, called for its side effect.
#' @seealso [docling_available()], [docling_convert()]
#' @export
install_docling <- function(envname = "r-docling",
                            method = c("auto", "virtualenv", "conda"),
                            extra = NULL,
                            ...) {
  method <- rlang::arg_match(method)
  packages <- c("docling", extra)

  cli::cli_alert_info("Installing {.val {packages}} into environment {.val {envname}}.")
  reticulate::py_install(
    packages = packages,
    envname = envname,
    method = method,
    ...
  )
  cli::cli_alert_success(
    "Docling installed. Restart R, then check with {.run doclingr::docling_available()}."
  )
  invisible(NULL)
}

#' Is the Docling backend available?
#'
#' Checks whether the `docling` Python package can be imported in the active
#' 'reticulate' environment.
#'
#' @return A logical scalar.
#' @seealso [install_docling()]
#' @export
#' @examples
#' \dontrun{
#' docling_available()
#' }
docling_available <- function() {
  reticulate::py_module_available("docling")
}
