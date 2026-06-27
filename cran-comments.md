## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* local macOS, R 4.6.0
* GitHub Actions: ubuntu-latest (release, devel), macOS-latest, windows-latest

## Notes for CRAN

* This package is an interface to the Docling Python library via 'reticulate'.
  The Python backend is an optional system requirement; it is not needed to
  install or check the package.
* All examples that require the Python backend are wrapped in `\dontrun{}`, and
  tests self-skip when the backend is unavailable, so the package checks cleanly
  without Python or any model downloads.
* `install_docling()` installs into a 'reticulate'-managed environment only when
  the user explicitly calls it; nothing is written outside the session
  otherwise.
