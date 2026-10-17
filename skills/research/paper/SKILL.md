---
name: paper
description: "Viết báo cáo theo một trong hai dạng: chuẩn quốc tế hoặc phổ biến tại Việt Nam. Tổng hợp nguồn có trích dẫn, giữ báo cáo chính gọn và tách dữ liệu hỗ trợ khi cần; xuất `.report.md` hoặc `.report.docx`."
license: MIT
metadata:
  audience: reporting
  origin: custom
---

> Bản tiếng Anh: [`SKILL.en.md`](SKILL.en.md)

# paper — viết báo cáo

Skill này soạn báo cáo từ nguồn đã thu thập. Chọn **một** trong hai dạng; không ghép hai bộ khung vào cùng một báo cáo.

## Hai dạng báo cáo

|Dạng|Tham chiếu|Dùng khi|
|---|---|---|
|Báo cáo chuẩn quốc tế|[`references/report-academic.md`](references/report-academic.md)|Cần cấu trúc nghiên cứu rõ, phương pháp có thể đánh giá và trích dẫn đầy đủ. Chọn hướng dẫn theo loại nghiên cứu; không tuyên bố tuân thủ một chuẩn nếu chưa kiểm checklist tương ứng.|
|Báo cáo phổ biến Việt Nam|[`references/report-template.md`](references/report-template.md)|Cần giải thích phát hiện cho độc giả phổ thông bằng tiếng Việt, giữ chính xác bằng chứng và giới hạn.|

Quy tắc chung nằm trong [`references/output-format.md`](references/output-format.md). Trích xuất tài liệu/media trước qua skill phù hợp khi cần.

## Quy tắc thực hiện

1. Hỏi cổng yêu cầu của `orchestrator`; chốt dạng báo cáo, độc giả, mục đích, ngôn ngữ và định dạng. Không hỏi lại thông tin đã có.
2. Chỉ dùng bộ khung của dạng đã chọn. Ngôn ngữ mặc định theo yêu cầu/ngữ cảnh; không ép song ngữ.
3. Giữ file `.report.md` tập trung vào nội dung và lập luận. Đưa trích xuất nguyên văn, bảng dữ liệu lớn, metadata kỹ thuật, nhật ký công cụ và phụ lục không thiết yếu vào file hỗ trợ riêng; giữ trích dẫn cần thiết ngay trong báo cáo.
4. Dùng công cụ local khi phù hợp. Báo cáo từ nguồn local phải có thể soạn và kiểm tra offline; truy cập URL/API hoặc dịch vụ ngoài chỉ khi nguồn/yêu cầu cần mạng. Không âm thầm chuyển sang dịch vụ từ xa.
5. Lưu `<tên_nguồn>.report.md` cạnh nguồn, không ghi đè nguồn. Đặt sidecar có hậu tố rõ như `.sources.md`, `.extract.txt`, `.data.csv`, `.transcript.md` hoặc `.diagram.png`.
6. Không bịa dữ liệu, trích dẫn hay số trang. Gắn nguồn cho nhận định; phân biệt dữ kiện, quan sát và suy luận khi cách viết chưa đủ rõ.
7. Kiểm tra liên kết trích dẫn, tính nhất quán và nội dung báo cáo. Khi xuất DOCX/PDF, dùng các công cụ local có sẵn để xác minh văn bản và trang; báo rõ nếu công cụ không khả dụng.
8. Trả lời cùng ngôn ngữ người dùng nói và nêu tên/đường dẫn mọi file đã tạo.

## Xuất DOCX và PDF

Ưu tiên công cụ local đã cài. Nếu cần chuyển đổi phức tạp, tham chiếu skill `doc` — [`doc-recipes.md`](../doc/references/doc-recipes.md). Kiểm tra đầu ra bằng `pdfinfo` và `pdftotext` khi có thể.

## Nguồn nghiên cứu

Các nguồn dùng để xây dựng nguyên tắc báo cáo được ghi tại [`references/reporting-principles-sources.md`](references/reporting-principles-sources.md); đây là tài liệu tham khảo của skill, không phải phần bắt buộc chèn vào mỗi báo cáo.
