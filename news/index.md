# Changelog

## doclingr 0.1.1

- [`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)
  gains a `doc_items` list-column with per-item provenance: `self_ref`,
  `label`, `page` and a 1-based inclusive character span
  (`char_start`/`char_end`) locating each occurrence within the
  originating item’s text (populated by layout analysis; `NA` for
  formats without provenance, such as Markdown sources).
- New
  [`docling_write_chunks()`](https://strategicprojects.github.io/doclingr/reference/docling_write_chunks.md)
  persists chunk tibbles — including `embedding` and other list-columns
  — to Parquet or Feather via the arrow package (new optional dependency
  in Suggests), for hand-off to Python, DuckDB and other Arrow-aware RAG
  tooling.
- [`vignette("options")`](https://strategicprojects.github.io/doclingr/articles/options.md)
  gains a “Model cache and offline use” section covering `HF_HOME` and
  `HF_HUB_OFFLINE` for air-gapped machines.
- Confirmed compatible with Docling 2.143.1 (full test suite).

## doclingr 0.1.0

CRAN release: 2026-07-10

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
