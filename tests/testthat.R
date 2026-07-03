# CRAN allows at most 2 cores during checks. reticulate initialises Python
# (numpy/OpenBLAS/OpenMP), which by default spawns one thread per core and
# trips the "CPU time > 2.5 times elapsed time" incoming check, so cap all
# threading knobs before anything touches Python.
Sys.setenv(
  OMP_NUM_THREADS = "1",
  OMP_THREAD_LIMIT = "2",
  OPENBLAS_NUM_THREADS = "1",
  MKL_NUM_THREADS = "1",
  NUMEXPR_NUM_THREADS = "1",
  VECLIB_MAXIMUM_THREADS = "1",
  TOKENIZERS_PARALLELISM = "false"
)

library(testthat)
library(doclingr)

test_check("doclingr")
