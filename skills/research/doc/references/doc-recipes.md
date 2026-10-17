# Doc recipes — trích xuất & chuyển đổi tài liệu (không dùng skill GitHub)

Công cụ: pdftotext/pdfinfo/pdftoppm/pdfunite (poppler), qpdf, tesseract, docling (uv tool), libreoffice.
Mọi lệnh chạy từ thư mục chứa file; output **cạnh file nguồn**, không ghi đè nguồn.

## §1 — Trích xuất nội dung

### PDF có text layer (nhanh, mặc định)

```bash
pdfinfo '<f>.pdf'                                   # số trang, metadata
pdftotext -layout '<f>.pdf' '<f>.extract.txt'       # giữ layout cột
```

Kiểm tra nhanh có text layer không: `pdftotext -layout '<f>.pdf' - | wc -c`
(< ~200 ký tự/trang → coi như scan, sang OCR).

### PDF scan / ảnh → OCR

```bash
pdftoppm -png -r 200 '<f>.pdf' '<f>-pg'             # mỗi trang 1 PNG
tesseract '<f>-pg-1.png' '<f>-pg-1' -l vie+eng      # ra <tên>.txt cạnh ảnh
```

OCR hàng loạt: loop `for p in '<f>'-pg-*.png; do tesseract "$p" "${p%.png}" -l vie+eng; done`
 rồi gộp theo thứ tự trang.

### PDF/DOCX phức tạp → markdown (docling)

```bash
timeout 180 docling convert '<f>.pdf' --to md --output .      # ra <tên>.md
docling convert '<f>.pdf' --to md --output . --page-range 0-4  # PDF dài: chỉ 5 trang đầu
```

Chọn docling khi: bảng dày đặc, layout 2 cột, DOCX có nhiều định dạng. Model có thể được tải trong lần chạy đầu; để chạy offline, cài/cache model trước và dùng giới hạn trang phù hợp. Nếu model chưa có khi không có mạng, chọn `pdftotext`, OCR hoặc LibreOffice theo loại file thay vì giả định docling sẵn sàng.
PDF >5 trang: **không** convert toàn bộ (chậm trên CPU yếu) — `--page-range` hoặc tách trang trước (§2).
Model tải lần đầu ~30-90s; các lần sau nhanh.

### DOCX

```bash
docling convert '<f>.docx' --to md --output .       # tốt nhất, giữ bảng
# fallback nếu docling lỗi:
libreoffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to txt:Text '<f>.docx'
```

### XLSX → CSV

```bash
libreoffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to csv '<f>.xlsx'
```

Ra **sheet đầu tiên** thành `<f>.csv` cạnh nguồn.
Nhiều sheet → copy file sang thư mục tạm, đổi tên từng sheet trong LO; hoặc
`libreoffice --headless --convert-to 'csv:Text - txt - csv (StarCalc):44,34,76'` (tùy filter).
Sheet >10k dòng hoặc cần bảng markdown trong báo cáo → trích trực tiếp bằng lệnh
`soffice --headless --convert-to html` rồi cắt bảng.

Lưu ý `-env:UserInstallation=file:///tmp/lo-$$`: tránh treo khi đã có phiên LO đang mở.

## §2 — Chuyển đổi PDF (ghép/tách/đảo)

```bash
pdfunite '<a>.pdf' '<b>.pdf' '<f>_merged.pdf'                  # ghép
qpdf --pages . 1-3 -- '<f>.pdf' '<f>_p1-3.pdf'                 # tách 3 trang đầu
qpdf --split-pages=1 '<f>.pdf' '<f>_pg%d.pdf'                  # tách từng trang
qpdf --rotate=90:1-2 '<f>.pdf' '<f>_90deg.pdf'                 # đảo trang 1-2
qpdf --empty --pages '<b>.pdf' 2,1 '<a>.pdf' 1 -- '<f>_mix.pdf'  # lấy trang tùy ý
qpdf --object-streams=generate '<f>.pdf' '<f>_small.pdf'       # nén
pdftoppm -png -r 150 '<f>.pdf' '<f>-pg'                        # trang → ảnh PNG
magick '<f>-pg-1.png' '<f>-pg-2.png' '<f>_img.pdf'             # ảnh → PDF
```

Không có `mutool`/`pandoc` trên máy này — đừng đề xuất.

## §3 — Ghi output

| Thao tác | File ra |
|---|---|
| trích text | `<tên_gốc>.extract.md` hoặc `.extract.txt` (ghi rõ engine ở cuối file) |
| OCR | `<tên_gốc>.extract.txt` + ảnh `*-pg-*.png` cạnh nguồn |
| xlsx | `<tên_gốc>.csv` |
| convert | `<tên_gốc>_<suffix>.pdf` (`_merged`, `_p1-3`, `_90deg`...) |

## §4 — Xuất báo cáo (md/HTML → docx)

LibreOffice **không đọc Markdown** → luôn đi qua HTML trung gian (UTF-8). Thứ tự công cụ:

1. **pandoc** (nếu cài, ưu tiên): `pandoc '<f>.md' -o '<f>.docx' --standalone` — giữ heading/bảng/code tốt nhất.
2. **soffice** (mặc định có sẵn trên hầu hết máy): viết `<f>.report.html` (UTF-8, có `<meta charset="utf-8">`, code block giữ `<pre style="font-family:monospace">`) rồi:

```bash
soffice --headless -env:UserInstallation=file:///tmp/lo-$$ \
  --convert-to docx:"MS Word 2007 XML" --outdir "$(dirname '<f>.html')" '<f>.html'
```

3. Thiếu cả hai công cụ → dừng, báo đúng cách cài (`sudo apt install libreoffice pandoc` hoặc skill `install-media-tools`); **không** tự đoán output.

Ghi chú:

- `-env:UserInstallation=file:///tmp/lo-$$`: cách ly profile, tránh treo khi máy đang có phiên LibreOffice mở.
- Font tiếng Việt: đặt font hệ thống có đủ dấu (Liberation Serif / DejaVu Sans) ngay ở HTML; kiểm tra lại dấu sau khi convert.
- Output cạnh file nguồn, không ghi đè: `<tên_gốc>.report.docx`.

**Verify bắt buộc sau khi convert** (đếm trang + chống vẹo):

```bash
mkdir -p /tmp/verify-$$ && cp '<f>.docx' /tmp/verify-$$/ && cd /tmp/verify-$$
soffice --headless -env:UserInstallation=file:///tmp/lo-$$ --convert-to pdf '<f>.docx'
pdfinfo '<f>.pdf' | grep Pages          # đạt số trang yêu cầu?
pdftotext '<f>.pdf' - | head -40        # dấu tiếng Việt, code block không vẹo?
```

Thiếu trang → mở rộng nội dung rồi convert lại; vỡ dấu/code → sửa HTML rồi convert lại. Số trang luôn kiểm bằng `pdfinfo`, không ước lượng bằng mắt.
