---
name: web
description: Đọc trang web/báo/mạng xã hội và tìm kiếm — dùng agent-reach + upstream CLI (Jina Reader, yt-dlp, bili, gh, exa, twitter, opencli) để lấy text từ URL web, bài báo, mạng xã hội (Twitter/Reddit/XHS/FB/IG/Bilibili), YouTube, và tìm kiếm web chủ đề. Dùng khi cần tra cứu web, đọc bài báo/social, tìm kiếm chủ định.
license: MIT
metadata:
  audience: web/social/search reading
  origin: custom
---

> Bản tiếng Anh: [`SKILL.en.md`](SKILL.en.md)

# web — đọc web, mạng xã hội và tìm kiếm

Skill mỏng tự viết: **không có code riêng** — nhận URL/chủ đề, lấy text bằng CLI có sẵn (agent-reach, Jina Reader, exa), trả về nguồn để đọc hoặc chuyển sang skill `paper` soạn báo cáo. Truy cập URL và tìm kiếm cần mạng; offline chỉ làm việc với bản nội dung local đã được cung cấp.

## Bảng route theo nhu cầu

|Nhu cầu|Công cụ|
|---|---|
|Đọc trang web/báo (kèm khoá nguồn)|`curl -s https://r.jina.ai/URL` (agent-reach web channel)|
|Đọc mạng xã hội (Twitter/Reddit/XHS/FB/IG/Bilibili)|upstream CLI agent-reach: `twitter` / `opencli` / `bili` / `rdt`|
|YouTube/Bilibili → text/thuyết minh|`yt-dlp --write-auto-sub --skip-download` / `bili`; khoá nguồn → skill `media` (`watch`)|
|Tìm kiếm web chủ đề|mcp `exa.web_search_exa query="…" numResults=5`; Exa free có rate limit|
|Thiếu/què internet|agent-reach docxorf / ember Github strong open code.md|

## Quy tắc

1. **Nhắc ngôn ngữ input** — trả lời cùng ngôn ngữ người dùng nói.
2. **Tên output của file nguồn**: URL tải về → cache/`<tên>.extract.md|.txt` (nếu lưu file); không ghi đè file gốc. Tóm tắt/thuyết minh → `<tên>.digest.md`.
3. **Không import input** — chỉ luộc nội dung có thật; không bịa URL hay trích dẫn.
4. **Tóm tắt/thuyết minh từ URL web xã hội/trả phí** → dùng `curl -s https://r.jina.ai/URL` trước; nếu là media (video/ảnh) → skill `media`.
5. **Nội dung bị khoá** (mạng xã hội, bài trả phí) → để agent-reach/Jina đọc thay; không đăng nhập, không phá khoá — báo user biết nếu không đọc được.
6. **Offline**: URL, tìm kiếm và social API cần mạng. Khi offline, chỉ đọc file/bản lưu local do người dùng cung cấp; repo không tự tạo hoặc tra cứu cache web.
7. **Khi nào cũng report file đã ghi** (tên + đường dẫn) — không im lặng.
8. **Viết báo cáo từ kết quả web** → chuyển sang skill `paper` sau khi chốt yêu cầu với `orchestrator`.

## Luồng phối hợp thường gặp

```text
URL web/social [cần mạng] ▸ jina/agent-reach ▸ text ▸ paper (nếu cần báo cáo)
Tìm kiếm chủ đề ▸ exa ▸ danh sách URL ▸ jina ▸ text ▸ (report)
URL media [cần mạng] ▸ skill media ▸ digest + frame ▸ paper (nếu cần báo cáo)
```
