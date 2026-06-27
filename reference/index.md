# Package index

## Setup

Install and check the Docling Python backend.

- [`install_docling()`](https://strategicprojects.github.io/doclingr/reference/install_docling.md)
  : Install the Docling Python backend
- [`docling_available()`](https://strategicprojects.github.io/doclingr/reference/docling_available.md)
  : Is the Docling backend available?

## Convert

Turn documents into structured handles.

- [`docling_convert()`](https://strategicprojects.github.io/doclingr/reference/docling_convert.md)
  : Convert one or more documents with Docling
- [`docling_n_pages()`](https://strategicprojects.github.io/doclingr/reference/docling_n_pages.md)
  : Number of pages in a converted document

## Export

Render a converted document into downstream formats.

- [`as_markdown()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)
  [`as_text()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)
  [`as_html()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)
  [`as_json()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)
  [`as_doctags()`](https://strategicprojects.github.io/doclingr/reference/docling_export.md)
  : Export a converted document

## Extract

Mine tables and figures.

- [`docling_tables()`](https://strategicprojects.github.io/doclingr/reference/docling_tables.md)
  : Extract tables as data frames
- [`docling_figures()`](https://strategicprojects.github.io/doclingr/reference/docling_figures.md)
  : Extract figures (pictures) from a converted document

## RAG pipeline

Chunk documents and attach embeddings.

- [`docling_chunk()`](https://strategicprojects.github.io/doclingr/reference/docling_chunk.md)
  : Split a document into RAG-ready chunks
- [`docling_embed()`](https://strategicprojects.github.io/doclingr/reference/docling_embed.md)
  : Attach embeddings to chunks
