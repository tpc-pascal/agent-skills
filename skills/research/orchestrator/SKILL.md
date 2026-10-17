---
name: orchestrator
description: Điều phối — nhận input, xác định loại, chuyển tiếp tới skill anh em trong repo — doc (tài liệu), media (video/audio/ảnh), paper (báo cáo), web (đọc web/mạng xã hội/tìm kiếm) — và mở cổng câu hỏi bắt buộc trước khi viết báo cáo. Dùng khi chưa biết skill nào xử lý input đang có, hoặc khi cần quy trình phối hợp nhiều skill.
license: MIT
metadata:
  audience: orchestration
  origin: custom
---

> Bản tiếng Anh: [`SKILL.en.md`](SKILL.en.md)

# orchestrator — điều phối đầu vào

Skill mỏng tự viết: **không có code riêng** — nhận input, xác định loại, đưa tới nơi xử lý đúng.

## Kỹ năng trong repo này

|Skill|Dùng khi|
|---|---|
|`doc`|PDF/DOCX/XLSX: lấy text, OCR, chuyển đổi, tách/ghép trang|
|`media`|video/audio/ảnh/URL: tóm tắt, trích text, phụ đề, cắt ghép, frame, tải|
|`paper`|viết báo cáo chuẩn quốc tế hoặc báo cáo phổ biến Việt Nam|
|`web`|đọc trang web/báo/mạng xã hội + tìm kiếm (Jina, agent-reach, exa)|
|`diagram`|vẽ sơ đồ Mermaid / biểu đồ matplotlib cho báo cáo|
|`orchestrator` (skill này)|điều phối các skill trên + cổng câu hỏi trước báo cáo|

Cài đủ để điều phối hoạt động: `npx skills add tpc-pascal/agent-skills --all` (hoặc `--skill orchestrator web doc media paper diagram`).

## Bảng route theo loại input

|Input + nhu cầu|Nơi xử lý|
|---|---|
|PDF/DOCX/XLSX (text, OCR, chuyển đổi, tách/ghép)|skill `doc`|
|video/audio/ảnh/URL media (tóm tắt, phụ đề, cắt, frame, tải)|skill `media`|
|Đọc web/mạng xã hội/tìm kiếm (URL, bài báo, exa)|skill `web`|
|Viết báo cáo từ nguồn|**Cổng câu hỏi** (mục dưới đây) → chọn một dạng trong skill `paper`|
|Vẽ sơ đồ/biểu đồ cho báo cáo|skill `diagram`|

## Chốt yêu cầu báo cáo

**Trigger:** người dùng yêu cầu tạo hoặc viết lại báo cáo; không áp dụng cho yêu cầu chỉ trích xuất/chuyển đổi.

Trước khi nghiên cứu sâu hoặc soạn báo cáo, hỏi một lượt tối đa 4 câu, chỉ hỏi phần còn thiếu:

- **Dạng:** báo cáo chuẩn quốc tế hoặc báo cáo phổ biến Việt Nam?
- **Mục đích và độc giả:** ai sẽ đọc, cần trả lời điều gì?
- **Đầu ra:** ngôn ngữ, định dạng và giới hạn độ dài nếu có?
- **Nguồn và phạm vi:** nguồn/phần nào cần dùng; có cho phép bổ sung nguồn ngoài không?

- Không hỏi lại điều đã có trong yêu cầu/hội thoại. Nếu người dùng giao quyền tự quyết, chọn phương án phù hợp và nêu giả định ngắn gọn khi chúng ảnh hưởng kết quả.
- Không cần chờ câu trả lời cho thông tin không thiết yếu; không bắt buộc chọn đề mục chi tiết trước khi biết nguồn.
- Trích xuất bằng skill phù hợp, sau đó viết theo đúng một dạng của `paper`.

## Quy tắc điều phối

1. **Nhắc ngôn ngữ input** — trả lời cùng ngôn ngữ người dùng nói.
2. **Ghi rõ output của file nguồn**: `<tên_gốc>.<suffix>`. Không ghi đè file. Suffix: tài liệu `.extract.md|.txt|.csv`, tóm tắt `.digest.md`, phụ đề `.srt|.vtt`, clip `.clip-<t1>-<t2>.mp4`, báo cáo `.report.md|.report.docx`.
3. **Không import input** — chỉ luộc file có thật, output đặt trong/thừa file; không tự thêm file.
4. **Input web/social/search** → skill `web` (Jina/agent-reach/exa) đọc trước; input media → skill `media`.
5. **Nội dung bị khoá** (mạng xã hội, bài trả phí) → để skill `web` (agent-reach/Jina) đọc thay; không đăng nhập, không phá khoá — báo user biết nếu không đọc được.
6. **Khi báo cáo/file báo cáo** (mọi `.report.docx`): verify theo skill `paper` — `pdfinfo` + `pdftotext`, không bịa.
7. **Media skill cần fetch theo phiên** → xem skill `media` (mục fetch) hoặc `scripts/fetch-session.sh --list`.
8. **Local-first**: ưu tiên công cụ local cho file local. Web/API cần kết nối; nếu offline thì chỉ dùng nguồn local/cache thực sự có sẵn hoặc do người dùng cung cấp, và nêu phần không truy cập được.
9. **Khi nào cũng report file đã ghi** (tên + đường dẫn) — không im lặng.

## Ký hiệu luồng

Trong sơ đồ dưới, `▸` nghĩa là bàn giao sang bước tiếp theo; `→` nghĩa là luồng tiếp tục; dấu ngoặc vuông mô tả loại nguồn hoặc kết quả. Đây là ký hiệu luồng, không phải nhãn nguồn hay định dạng đầu ra.

## Luồng phối hợp thường gặp

```text
PDF scan ▸ skill doc ▸ text/table ▸ skill paper ▸ báo cáo
URL web/social ▸ skill web ▸ text ▸ skill paper (nếu cần báo cáo)
URL/file video ▸ skill media ▸ digest + frame ▸ skill paper (nếu cần báo cáo)
SRT/mm:ss ▸ skill media ▸ trim ▸ concat
```
