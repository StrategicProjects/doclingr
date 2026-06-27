# Changelog

## doclingr 0.1.0

First release: an R interface to Docling for document intelligence and
RAG.

- [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)
  converts a file path or URL (or a vector of them) into a
  `docling_document`, with pipeline options for OCR, table mode,
  accelerator device/threads and image generation.
- Exporters
  [`as_markdown()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md),
  [`as_text()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md),
  [`as_html()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md),
  [`as_json()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)
  and
  [`as_doctags()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md).
- [`docling_tables()`](https://strategicprojects.github.io/doclingr/reference/docling_tables.md)
  returns detected tables as a list of tibbles.
- [`docling_figures()`](https://strategicprojects.github.io/doclingr/reference/docling_figures.md)
  returns figure captions/pages and can save images;
  [`docling_n_pages()`](https://strategicprojects.github.io/doclingr/reference/docling_n_pages.md)
  reports the page count.
- [`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)
  produces RAG-ready chunks as a tidy tibble, with hybrid and
  hierarchical chunkers, tokenizer/`max_tokens` control, and `pages`/
  `n_doc_items` metadata.
- [`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md)
  attaches embeddings from any user-supplied embedding function, with
  batching.
- [`install_docling()`](https://strategicprojects.github.io/doclingr/reference/install_docling.md)
  /
  [`docling_available()`](https://strategicprojects.github.io/doclingr/reference/docling_available.md)
  manage the Python backend.
