# Doc recipes — document extraction & conversion (no GitHub skills needed)

Tools: pdftotext/pdfinfo/pdftoppm/pdfunite (poppler), qpdf, tesseract, docling (uv tool), libreoffice.
Run every command from the directory containing the file; output goes **next to the source file**, never overwrite the source.

## §1 — Extracting content

### PDF with a text layer (fast, default)

```bash
pdfinfo '<f>.pdf' # page count, metadata
pdftotext -layout '<f>.pdf' '<f>.extract.txt' # keep column layout
```

Quick check for a text layer: `pdftotext -layout '<f>.pdf' - | wc -c`
(< ~200 chars/page → treat as scanned, switch to OCR).

### Scanned PDF / images → OCR

```bash
pdftoppm -png -r 200 '<f>.pdf' '<f>-pg' # one PNG per page
tesseract '<f>-pg-1.png' '<f>-pg-1' -l vie+eng # writes <name>.txt next to the image
```

Batch OCR: loop `for p in '<f>'-pg-*.png; do tesseract "$p" "${p%.png}" -l vie+eng; done`
 then merge in page order.

### Complex PDF/DOCX → markdown (docling)

```bash
timeout 180 docling convert '<f>.pdf' --to md --output . # writes <name>.md
docling convert '<f>.pdf' --to md --output . --page-range 0-4 # long PDF: only first 5 pages
```

Choose docling when: dense tables, two-column layout, DOCX with heavy formatting. A model may be downloaded on first use; for offline operation, install/cache it in advance and limit the page range as appropriate. If the model is unavailable offline, use `pdftotext`, OCR, or LibreOffice as appropriate rather than assuming Docling is ready.
PDF >5 pages: **never** convert the whole file (slow on weak CPUs) — use `--page-range` or split pages first (§2).
First run downloads the model (~30-[X]s); later runs are faster.

### DOCX

```bash
docling convert '<f>.docx' --to md --output . # best, keeps tables
# fallback if docling fails:
libreoffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to txt:Text '<f>.docx'
```

### XLSX → CSV

```bash
libreoffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to csv '<f>.xlsx'
```

Produces the **first sheet** as `<f>.csv` next to the source.
Multiple sheets → copy the file to a temp dir and rename sheets in LO; or use
`libreoffice --headless --convert-to 'csv:Text - txt - csv (StarCalc):44,34,76'` (filter options).
Sheets >10k rows, or a markdown table needed in a report → extract via
`soffice --headless --convert-to html` and cut the table out.

Note `-env:UserInstallation=file:///tmp/lo-$$`: avoids hangs when another LO session is open.

## §2 — PDF conversion (merge/split/rotate)

```bash
pdfunite '<a>.pdf' '<b>.pdf' '<f>_merged.pdf' # merge
qpdf --pages . 1-3 -- '<f>.pdf' '<f>_p1-3.pdf' # split first 3 pages
qpdf --split-pages=1 '<f>.pdf' '<f>_pg%d.pdf' # split every page
qpdf --rotate=90:1-2 '<f>.pdf' '<f>_90deg.pdf' # rotate pages 1-2
qpdf --empty --pages '<b>.pdf' 2,1 '<a>.pdf' 1 -- '<f>_mix.pdf' # pick arbitrary pages
qpdf --object-streams=generate '<f>.pdf' '<f>_small.pdf' # compress
pdftoppm -png -r 150 '<f>.pdf' '<f>-pg' # pages → PNG images
magick '<f>-pg-1.png' '<f>-pg-2.png' '<f>_img.pdf' # images → PDF
```

No `mutool`/`pandoc` on this machine — do not suggest them.

## §3 — Output naming

|Operation|Output file|
|---|---|
|text extraction|`<orig_name>.extract.md` or `.extract.txt` (state the engine at the end of the file)|
|OCR|`<orig_name>.extract.txt` + images `*-pg-*.png` next to the source|
|xlsx|`<orig_name>.csv`|
|convert|`<orig_name>_<suffix>.pdf` (`_merged`, `_p1-3`, `_90deg`...)|

## §4 — Report export (md/HTML → docx)

LibreOffice **cannot read Markdown** → always go through an intermediate HTML file (UTF-8). Tool order:

1. **pandoc** (if installed, preferred): `pandoc '<f>.md' -o '<f>.docx' --standalone` — best at preserving headings/tables/code blocks.
2. **soffice** (usually preinstalled): write `<f>.report.html` (UTF-8, `<meta charset="utf-8">`, keep code blocks as `<pre style="font-family:monospace">`) then:

```bash
soffice --headless -env:UserInstallation=file:///tmp/lo-$$ \
  --convert-to docx:"MS Word 2007 XML" --outdir "$(dirname '<f>.html')" '<f>.html'
```

3. Neither tool present → stop and report the install command (`sudo apt install libreoffice pandoc` or the `install-media-tools` skill); **never** guess the output.

Notes:

- `-env:UserInstallation=file:///tmp/lo-$$`: isolates the user profile, prevents hangs when another LibreOffice window is open.
- Vietnamese/UTF-8 fonts: pick fonts with full diacritics coverage (Liberation Serif / DejaVu Sans) in the HTML; re-check diacritics after conversion.
- Output goes next to the source file, never overwriting it: `<tên_gốc>.report.docx`.

**Mandatory post-convert verification** (page count + integrity):

```bash
mkdir -p /tmp/verify-$$ && cp '<f>.docx' /tmp/verify-$$/ && cd /tmp/verify-$$
soffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to pdf '<f>.docx'
pdfinfo '<f>.pdf' | grep Pages          # meets the required page count?
pdftotext '<f>.pdf' - | head -40        # diacritics intact, code blocks not mangled?
```

Too few pages → expand the content and re-convert; broken diacritics/code → fix the HTML and re-convert. Always measure pages with `pdfinfo`, never by eye.
