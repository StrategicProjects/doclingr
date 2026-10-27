# doclingr 0.1.1

* `docling_chunk()` gains a `doc_items` list-column with per-item provenance:
  `self_ref`, `label`, `page` and a 1-based inclusive character span
  (`char_start`/`char_end`) locating each occurrence within the originating
  item's text (populated by layout analysis; `NA` for formats without
  provenance, such as Markdown sources).
* New `docling_write_chunks()` persists chunk tibbles — including `embedding`
  and other list-columns — to Parquet or Feather via the arrow package (new
  optional dependency in Suggests), for hand-off to Python, DuckDB and other
  Arrow-aware RAG tooling.
* `vignette("options")` gains a "Model cache and offline use" section covering
  `HF_HOME` and `HF_HUB_OFFLINE` for air-gapped machines.
* Confirmed compatible with Docling 2.143.1 (full test suite).

# doclingr 0.1.0

First release: an R interface to Docling for document intelligence and RAG.

* `docling_convert()` converts a file path or URL (or a vector of them) into a
  `docling_document`, with pipeline options for OCR, table mode, accelerator
  device/threads and image generation.
* Exporters `as_markdown()`, `as_text()`, `as_html()`, `as_json()` and
  `as_doctags()`.
* `docling_tables()` returns detected tables as a list of tibbles.
* `docling_figures()` returns figure captions/pages and can save images;
  `docling_n_pages()` reports the page count.
* `docling_chunk()` produces RAG-ready chunks as a tidy tibble, with hybrid and
  hierarchical chunkers, tokenizer/`max_tokens` control, and `pages`/
  `n_doc_items` metadata.
* `docling_embed()` attaches embeddings from any user-supplied embedding
  function, with batching.
* `install_docling()` / `docling_available()` manage the Python backend.
