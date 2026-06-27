## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

The remaining NOTE is the standard "New submission".

## Test environments

* local macOS, R 4.6.0 (R CMD check --as-cran)
* GitHub Actions: ubuntu-latest (release, devel, oldrel-1), macOS-latest,
  windows-latest

## Notes for CRAN

* This package is an interface to the Docling Python library via 'reticulate'.
  The Python backend is an optional system requirement; it is not needed to
  install or check the package.
* All examples that require the Python backend are wrapped in `\dontrun{}`,
  vignettes are not evaluated, and tests self-skip when the backend is
  unavailable, so the package checks cleanly without Python or any model
  downloads.
* `install_docling()` installs into a 'reticulate'-managed environment only when
  the user explicitly calls it; nothing is written outside the session
  otherwise.
