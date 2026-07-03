## Resubmission

This is a resubmission. The incoming pre-test on Debian noted:

    Running R code in 'testthat.R' had CPU time 2.9 times elapsed time

This came from 'reticulate' initialising Python (and its numpy/OpenBLAS
stack, which starts one thread per core) during the tests. The test runner
now caps all threading environment variables (OMP_NUM_THREADS,
OPENBLAS_NUM_THREADS, etc.) before Python is touched, so the tests stay
within CRAN's 2-core limit.

Changes from the earlier review round (Konstanze Lauseker) are retained:

* Removed the redundant "for R" / "R" wording from the Title and Description.
* Removed the `install_docling()` example from `install_docling.Rd` so no
  example installs software. (The function itself is a thin, opt-in wrapper
  around `reticulate::py_install()` that only runs when the user calls it; no
  functions, examples, or vignettes install anything during check — vignettes
  are not evaluated.)

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
