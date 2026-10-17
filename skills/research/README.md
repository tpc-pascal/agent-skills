# research — bộ skill nghiên cứu

> Bản tiếng Anh: [`README.en.md`](README.en.md)

Bộ skill để trích xuất tài liệu, xử lý media, đọc web, vẽ sơ đồ và viết báo cáo. Mỗi skill có thể dùng riêng; `orchestrator` định tuyến khi quy trình có nhiều bước.

## Các skill

| Skill | Vai trò |
|---|---|
| [`orchestrator`](orchestrator/SKILL.md) | Xác định nhu cầu và phối hợp skill |
| [`doc`](doc/SKILL.md) | Đọc/chuyển đổi PDF, DOCX, XLSX |
| [`media`](media/SKILL.md) | Xử lý video, audio và ảnh |
| [`web`](web/SKILL.md) | Đọc và tìm kiếm nguồn trực tuyến |
| [`paper`](paper/SKILL.md) | Viết báo cáo chuẩn quốc tế hoặc phổ biến tại Việt Nam |
| [`diagram`](diagram/SKILL.md) | Tạo sơ đồ và biểu đồ |

## Cài đặt

```bash
npx skills add tpc-pascal/agent-skills --skill orchestrator --skill doc --skill media --skill paper --skill web --skill diagram
```

Thay danh sách skill bằng tên skill cần cài để cài riêng.

## Luồng tổng quát

```text
Yêu cầu ▸ orchestrator ▸ doc / media / web ▸ paper ▸ diagram hoặc docx nếu cần ▸ kiểm tra
```

`▸` nghĩa là bàn giao sang bước kế tiếp; `/` nghĩa là chọn skill phù hợp, không nhất thiết chạy tất cả. Nguồn web/API cần mạng; xử lý file local ưu tiên công cụ local và có thể tiếp tục offline nếu các công cụ cần thiết đã có.

## Báo cáo

Skill `paper` hỗ trợ đúng hai dạng:

- **Báo cáo chuẩn quốc tế:** theo yêu cầu ngành, tạp chí hoặc tổ chức và guideline phù hợp với loại nghiên cứu.
- **Báo cáo phổ biến tại Việt Nam:** giải thích nội dung cho độc giả phổ thông bằng tiếng Việt rõ ràng; đây là dạng biên tập, không phải một chuẩn quốc gia chính thức.

Trước khi viết, xác nhận mục tiêu, độc giả, dạng báo cáo, ngôn ngữ, đầu ra và phạm vi nguồn nếu yêu cầu chưa nêu. Báo cáo chính tập trung vào nội dung; trích xuất dài, dữ liệu thô và tài sản hỗ trợ đặt trong file riêng khi cần.

## Kiểm tra

Chạy `bash scripts/smoke.sh` từ thư mục gốc repo để kiểm tra cú pháp, frontmatter, cấu trúc và file song ngữ.
