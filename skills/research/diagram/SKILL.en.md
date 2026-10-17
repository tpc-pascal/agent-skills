---
name: diagram
description: Draw nice diagrams and charts for reports — flowchart/sequence/class/state/ER/gantt via Mermaid (kroki.io, PNG), bar/pie/line charts via matplotlib (uv), output `<name>.diagram.png` next to the source for embedding into `.report.docx`. Use when a report needs real diagrams instead of ASCII, data charts, or the user asks for "nice diagrams".
license: MIT
metadata:
  audience: report diagrams / charts
  origin: custom
---

> Vietnamese version: [`SKILL.md`](SKILL.md)

# diagram — diagrams & charts

Thin skill with 2 scripts: `scripts/mmd2png.py` (Mermaid → PNG, local-only by default via `mmdc`; remote rendering requires explicit selection) and `scripts/chart.py` (data charts → PNG, matplotlib via `uv` or an installed Python environment). Sources live next to outputs; never overwrite existing files.

## Routing table

|Need|How|
|---|---|
|Flowchart / sequence / class / state / ER / gantt / system architecture|Mermaid → `scripts/mmd2png.py` (local `mmdc` only by default)|
|Bar / pie / line charts from real numbers|`scripts/chart.py` (matplotlib; `uv` may need network if the package is not cached)|
|Diagrams embedded in a `.report.docx`|PNG + `![title](<name>.diagram.png)` in `.report.md`, export with `paper` and the `doc` recipe|
|Anything beyond Mermaid/matplotlib (3D, heavy custom art)|`[N/A]` — tell the user the limit, never invent a method|

## Rules

1. **Output next to the source**: `<name>.diagram.png` (image) + `<name>.diagram.mmd` (editable Mermaid source). Never overwrite sources.
2. **Mermaid**: write into `.mmd`, render with `python3 scripts/mmd2png.py '<f>.mmd' '<f>.diagram.png'`; label diagrams in the user's language.
3. **Chart numbers must be measured/sourced values** (label `[fact]`/`[observed]`); never plot invented data.
4. **Local-first; no silent source upload**: by default, `mmd2png.py` uses only `mmdc`; if the CLI/browser is missing or rendering fails, stop and report why without network access. Install `npm i -g @mermaid-js/mermaid-cli` and Chrome/Chromium. Only when explicitly selected by the user/agent, set `MMD2PNG_BACKEND=remote` (Kroki then mermaid.ink), `kroki`, or `ink`. `chart.py` processes locally; `uv run --with matplotlib` may need network to obtain an uncached package, so offline use requires matplotlib in the active Python environment or a prepared cache.
5. **Verify before delivering**: `mmd2png.py` self-checks PNG magic + ≥ 1 KB; JPEGs from remote backends are converted to real PNG via ImageMagick (no converter → writes `<f>.jpg` with a warning, never faking `.png`); when embedded in a report, re-check with `pdfinfo` + `pdftotext` after DOCX→PDF conversion (image visible, pages not broken).
6. **Sizing**: one idea per diagram, legible font; too wide → split instead of letting the renderer shrink it into illegibility.
7. **Match the input language** — answer in the language the user used.

## scripts

- `scripts/mmd2png.py` — Mermaid → PNG (local-only by default; remote opt-in via `MMD2PNG_BACKEND`): `python3 scripts/mmd2png.py '<f>.mmd' '<f>.diagram.png' [--scale 2] [--size 1600] [--theme forest]`
- `scripts/chart.py` — 2-column CSV (label,value) → PNG: `uv run --with matplotlib python3 scripts/chart.py '<f>.csv' '<f>.diagram.png' <bar|pie|line>`
