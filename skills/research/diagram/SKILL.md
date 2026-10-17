---
name: diagram
description: Vẽ sơ đồ và biểu đồ đẹp cho báo cáo — flowchart/sequence/class/state/ER/gantt bằng Mermaid (kroki.io, PNG), biểu đồ cột/tròn/line bằng matplotlib (uv), output `<tên>.diagram.png` cạnh nguồn để nhúng vào `.report.docx`. Dùng khi báo cáo cần sơ đồ thay cho ASCII, cần biểu đồ dữ liệu, hoặc user yêu cầu "sơ đồ đẹp".
license: MIT
metadata:
  audience: report diagrams / charts
  origin: custom
---

> Bản tiếng Anh: [`SKILL.en.md`](SKILL.en.md)

# diagram — sơ đồ & biểu đồ

Skill mỏng, có 2 script: `scripts/mmd2png.py` (Mermaid → PNG, local-only mặc định qua `mmdc`; remote chỉ khi chọn rõ) và `scripts/chart.py` (biểu đồ số liệu → PNG, matplotlib qua `uv` hoặc Python có sẵn). Nguồn nằm cạnh output, không ghi đè file có sẵn.

## Bảng route theo nhu cầu

|Nhu cầu|Cách làm|
|---|---|
|Flowchart / sequence / class / state / ER / gantt / kiến trúc hệ thống|Mermaid → `scripts/mmd2png.py` (mặc định chỉ dùng `mmdc` local)|
|Biểu đồ cột / tròn / line từ số liệu thật|`scripts/chart.py` (matplotlib; `uv` có thể cần mạng nếu package chưa có trong cache)|
|Sơ đồ nhúng báo cáo `.report.docx`|PNG + `![tiêu đề](<tên>.diagram.png)` trong `.report.md`, xuất docx theo skill `paper` và recipe `doc`|
|Sơ đồ ngoài khả năng Mermaid/matplotlib (3D, đồ hoạ tuỳ biến cao)|`[N/A]` — báo user rõ giới hạn, không bịa cách|

## Quy tắc

1. **Output cạnh nguồn**: `<tên_gốc>.diagram.png` (ảnh) + `<tên_gốc>.diagram.mmd` (nguồn Mermaid, sửa được). Không ghi đè file nguồn.
2. **Mermaid**: viết vào `.mmd`, render `python3 scripts/mmd2png.py '<f>.mmd' '<f>.diagram.png'`; nhãn sơ đồ theo ngôn ngữ người dùng nói.
3. **Số liệu vẽ vào biểu đồ phải là số đo/thuật từ nguồn** (nhãn `[fact]`/`[observed]`); không vẽ số bịa.
4. **Local-first, không gửi nguồn âm thầm**: mặc định `mmd2png.py` chỉ dùng `mmdc`; thiếu CLI/browser hoặc lỗi thì dừng và báo lý do, không gọi mạng. Cài `npm i -g @mermaid-js/mermaid-cli` và Chrome/Chromium. Chỉ khi người dùng/agent chọn rõ mới đặt `MMD2PNG_BACKEND=remote` (Kroki rồi mermaid.ink), `kroki` hoặc `ink`. `chart.py` xử lý local; `uv run --with matplotlib` có thể cần mạng để lấy package nếu chưa cài/cache, nên khi offline dùng Python có matplotlib sẵn hoặc cache đã chuẩn bị.
5. **Verify trước khi giao**: `mmd2png.py` tự kiểm PNG magic + dung lượng ≥ 1 KB, ảnh JPEG từ remote được convert sang PNG thật bằng ImageMagick (thiếu converter → ghi `<f>.jpg` + cảnh báo, không giả làm `.png`); khi nhúng báo cáo → kiểm lại bằng `pdfinfo` + `pdftotext` sau khi convert DOCX→PDF (ảnh hiển thị, không vỡ trang).
6. **Kích thước**: mỗi sơ đồ 1 ý, font đủ đọc; sơ đồ quá rộng → tách nhỏ thay vì để trình soạn thảo co cụm.
7. **Nhắc ngôn ngữ input** — trả lời cùng ngôn ngữ người dùng nói.

## scripts

- `scripts/mmd2png.py` — Mermaid → PNG (local-only mặc định; remote opt-in qua `MMD2PNG_BACKEND`): `python3 scripts/mmd2png.py '<f>.mmd' '<f>.diagram.png' [--scale 2] [--size 1600] [--theme forest]`
- `scripts/chart.py` — số liệu CSV (2 cột: nhãn,giá trị) → PNG: `uv run --with matplotlib python3 scripts/chart.py '<f>.csv' '<f>.diagram.png' <bar|pie|line>`
