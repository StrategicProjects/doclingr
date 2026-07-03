# Install the Docling Python backend

Installs the `docling` Python package (and its dependencies) into a
'reticulate'-managed environment. This is a thin wrapper around
[`reticulate::py_install()`](https://rstudio.github.io/reticulate/reference/py_install.html)
that you typically run once after installing doclingr.

## Usage

``` r
install_docling(
  envname = "r-docling",
  method = c("auto", "virtualenv", "conda"),
  extra = NULL,
  ...
)
```

## Arguments

- envname:

  Name of, or path to, the target Python environment. Defaults to
  `"r-docling"`, created on first use.

- method:

  Installation method passed to
  [`reticulate::py_install()`](https://rstudio.github.io/reticulate/reference/py_install.html):
  one of `"auto"`, `"virtualenv"`, or `"conda"`.

- extra:

  Optional character vector of additional pip/conda specs to install
  alongside Docling (for example `"docling[ocr]"` or a pinned version
  such as `"docling==2.0.0"`).

- ...:

  Further arguments forwarded to
  [`reticulate::py_install()`](https://rstudio.github.io/reticulate/reference/py_install.html).

## Value

Invisibly `NULL`, called for its side effect.

## See also

[`docling_available()`](https://strategicprojects.github.io/doclingr/reference/docling_available.md),
[`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)
