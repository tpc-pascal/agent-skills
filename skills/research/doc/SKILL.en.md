---
name: doc
description: Extract and convert PDF/DOCX/XLSX documents — pull text layer (pdftotext), OCR scans (pdftoppm + tesseract), convert to markdown (docling), XLSX to CSV (libreoffice headless), merge/split/rotate pages (qpdf/pdftk), verify output with pdfinfo + pdftotext. Use when given a document and you need its text, OCR of a scan, format conversion, page merge/split, or verification of extracted content.
license: MIT
metadata:
  audience: document processing
  origin: custom
---

> Vietnamese version: [`SKILL.md`](SKILL.md)

# doc — document processing (PDF/DOCX/XLSX)

Thin skill, **no code of its own**: routes to local CLIs (`pdftotext`, `tesseract`, `qpdf`, `pdftk`, `docling`, `libreoffice`) using the recipes in [`references/doc-recipes.md`](references/doc-recipes.md).

## Routing table by input type

Identify the type with `file <f>` and by opening one page.

|Input + need|Main command|Notes|
|---|---|---|
|PDF with text layer, want text|`pdftotext -layout`|§1|
|Scanned PDF/image, want text|OCR `pdftoppm` + `tesseract`|§1|
|Complex PDF/DOCX (tables, layout) → markdown/JSON|official `docling` skill (fetch `--skill docling`), fallback `docling convert --to md`|§1 — PDF >5 pages: `--page-range`, timeout 180|
|XLSX → CSV/markdown|libreoffice headless|§1|
|Merge/split/rotate/extract PDF pages|`qpf`/`pdftk` + `pdfinfo`/`pdftoppm`|§2|
|Duplex/faded file, quick probe|skill `inspect` (mediaskills)|`uv run <inspect>/scripts/probe.py`|
|Verify freshly extracted output|`pdfinfo` + `pdftotext`|§4 — pages must match, text must not be empty|

## Rules

1. **Match the input language** — answer in the language the user used.
2. **Write output next to the source**: `<original_name>.extract.md|.txt|.csv`. Never overwrite the source.
3. **Label sources extracted from scans**: mark `[ocr]` — never blend with observed content.
4. **Verify before delivering**: page count must match (`pdfinfo`), extracted text must match the pages (`pdftotext`); missing/empty → re-extract.
5. **Local-first**: processing commands run on the machine; offline operation depends on the required CLIs, OCR/Docling models, and data being installed or cached. First-time Docling use may download a model; fetching third-party skills also requires network. If a model/tool is missing, disclose it or choose another local recipe; do not claim offline completion.
6. After writing output, report the file written (name + path) — never silently.

## Third-party skill (fetched per session)

- Official `docling` skill (docling-project): CLI + Python SDK, PipelineOptions, OCR config, DoclingDocument JSON/markdown — deeper than the `docling convert` CLI in §1.
- Fetch per session: `./scripts/fetch-session.sh --skill docling` → temp, never permanently installed.
- No network / fetch fails: use an available local CLI recipe. `docling convert --to md` works offline only when its required model is cached; otherwise choose another method or disclose the dependency.

## references

- [`references/doc-recipes.md`](references/doc-recipes.md) — §1 extraction (PDF/OCR/docling/DOCX/XLSX), §2 PDF conversion, §3 writing output, §4 DOCX export for the `paper` skill.
