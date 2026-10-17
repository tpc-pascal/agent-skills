---
name: doc
description: Trích xuất và chuyển đổi tài liệu PDF/DOCX/XLSX — lấy text layer (pdftotext), OCR ảnh scan (pdftoppm + tesseract), chuyển markdown (docling), XLSX → CSV (libreoffice headless), ghép/tách/đảo trang (qpdf/pdftk), kiểm tra output bằng pdfinfo + pdftotext. Dùng khi đưa tài liệu và muốn lấy text, OCR bản scan, chuyển định dạng, tách/ghép/trang, hoặc xác minh nội dung đã trích.
license: MIT
metadata:
  audience: document processing
  origin: custom
---

> Bản tiếng Anh: [`SKILL.en.md`](SKILL.en.md)

# doc — xử lý tài liệu (PDF/DOCX/XLSX)

Skill mỏng, **không có code riêng**: route đến CLI local (`pdftotext`, `tesseract`, `qpdf`, `pdftk`, `docling`, `libreoffice`) theo công thức trong [`references/doc-recipes.md`](references/doc-recipes.md).

## Bảng route theo loại input

Nhận diện loại bằng `file <f>` và mở thử 1 trang.

|Input + nhu cầu|Lệnh chính|Ghi chú|
|---|---|---|
|PDF có text layer, lấy text|`pdftotext -layout`|§1|
|PDF scan/ảnh, lấy text|OCR `pdftoppm` + `tesseract`|§1|
|PDF/DOCX phức tạp (bảng, layout) → markdown/JSON|skill `docling` chính chủ (fetch `--skill docling`), fallback `docling convert --to md`|§1 — PDF >5 trang: `--page-range`, timeout 180|
|XLSX → CSV/markdown|libreoffice headless|§1|
|Gấp/tách/đảo/trích trang PDF|`qpdf`/`pdftk` + `pdfinfo`/`pdftoppm`|§2|
|File hai mặt/mờ, muốn probe nhanh|skill `inspect` (mediaskills)|`uv run <inspect>/scripts/probe.py`|
|Xác minh output vừa trích|`pdfinfo` + `pdftotext`|§4 — trang phải khớp, text không rỗng|

## Quy tắc

1. **Nhắc ngôn ngữ input** — trả lời cùng ngôn ngữ người dùng nói.
2. **Output đặt cạnh file nguồn**: `<tên_gốc>.extract.md|.txt|.csv`. Không ghi đè file gốc.
3. **Label nguồn khi trích từ ảnh scan**: ghi `[ocr]` — không trộn với nội dung quan sát được.
4. **Verify trước khi giao**: PDF phải đủ trang (`pdfinfo`), text trích ra phải khớp trang (`pdftotext`); thiếu/trống → trích lại.
5. **Local-first**: các lệnh xử lý chạy trên máy; khả năng offline phụ thuộc CLI, model OCR/Docling và dữ liệu cần thiết đã cài hoặc cache. Lần đầu dùng Docling có thể cần tải model; tải skill bên thứ ba cũng cần mạng. Nếu thiếu model/công cụ, báo rõ hoặc chọn recipe local khác — không khẳng định đã xử lý offline.
6. Ghi output xong báo cáo file đã ghi (tên + đường dẫn) — không im lặng.

## Skill bên thứ ba (fetch theo phiên)

- Skill `docling` chính chủ (docling-project): CLI + Python SDK, PipelineOptions, OCR config, DoclingDocument JSON/markdown — sâu hơn CLI `docling convert` ở §1.
- Tải theo phiên: `./scripts/fetch-session.sh --skill docling` → temp, không cài vĩnh viễn.
- Không có mạng / không fetch được: dùng recipe CLI sẵn có. `docling convert --to md` chỉ offline nếu model cần thiết đã có trong cache; nếu không, chọn phương án khác hoặc báo rõ phụ thuộc.

## references

- [`references/doc-recipes.md`](references/doc-recipes.md) — §1 trích xuất (PDF/OCR/docling/DOCX/XLSX), §2 chuyển đổi PDF, §3 ghi output, §4 xuất DOCX cho skill `paper`.
