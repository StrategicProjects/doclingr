# doclingr 0.0.0.9000 (development)

First development version: an R interface to Docling for document intelligence
and RAG.

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
