# doclingr 0.1.1

First update after the initial release (0.1.0, accepted 2026-07-10).

User-visible changes (see NEWS.md): `docling_chunk()` gains a `doc_items`
provenance list-column with character spans; new `docling_write_chunks()`
writes chunk tables to Parquet/Feather via the arrow package (added to
Suggests); expanded documentation on model caching and offline use; confirmed
compatibility with Docling 2.143.1.

## R CMD check results

0 errors | 0 warnings | 0 notes

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
  downloads. The new arrow-dependent tests skip when arrow is not installed.
* The test runner caps threading environment variables (OMP_NUM_THREADS,
  OPENBLAS_NUM_THREADS, etc.) before Python initialises, keeping the tests
  within CRAN's 2-core limit (fix retained from the 0.1.0 submission).
