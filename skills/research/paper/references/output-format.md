# Quy tắc chung cho báo cáo

## Nội dung và ngôn ngữ

- Chọn một trong hai dạng của skill `paper`; chỉ dùng các mục phục vụ mục tiêu và độc giả đã thống nhất.
- Viết bằng ngôn ngữ người dùng yêu cầu; mặc định theo ngôn ngữ hội thoại. Chỉ làm song ngữ khi được yêu cầu hoặc cần thiết cho mục đích báo cáo.
- Giữ báo cáo chính tập trung vào câu hỏi, phát hiện, giải thích và kết luận. Đặt bản trích xuất, dữ liệu lớn, transcript, nhật ký công cụ, metadata kỹ thuật và phụ lục dài trong file hỗ trợ riêng. Không tách thông tin cần thiết để hiểu lập luận hoặc kiểm tra trích dẫn.
- Không thêm mục chỉ để lấp độ dài. Nếu có giới hạn trang/từ, đáp ứng bằng nội dung có ích và nêu rõ giới hạn khi nguồn không đủ.

## Bằng chứng và ký hiệu

- Trích dẫn nguồn cho các nhận định có thể kiểm chứng; ghi trang, timestamp hoặc vị trí khi có. Không tạo số liệu, đường dẫn, trích dẫn hay vị trí nguồn.
- Dùng nhãn khi cần phân biệt trạng thái bằng chứng, không gắn nhãn máy móc cho mọi câu:
   - `[observed]`: nội dung quan sát trực tiếp trong ảnh/khung hình.
   - `[ocr]`: chữ nhận dạng từ ảnh hoặc tài liệu scan.
   - `[heard]`: lời nói hoặc phụ đề được nhận dạng.
   - `[fact]`: dữ kiện được nguồn đáng tin cậy hoặc phép đo xác nhận.
   - `[inference]`: diễn giải/suy luận, không phải nội dung nguồn trực tiếp.
   - `[N/A]`: thông tin không có hoặc không xác minh được; nêu lý do.
- Nhãn cho biết loại bằng chứng hoặc trạng thái nhận định; nhãn không thay thế trích dẫn.
- Dùng `[kiến thức chuẩn]` / `[standard knowledge]` chỉ khi người dùng cho phép mở rộng ngoài nguồn; nêu tài liệu tham khảo cụ thể.
- Phân biệt kết quả, diễn giải, bất định và giới hạn. Không trình bày tương quan như quan hệ nhân quả hoặc suy luận như kết luận đã được chứng minh.

## Tệp và kiểm tra

- Ghi `.report.md` cạnh file nguồn, không ghi đè nguồn. Với URL, dùng thư mục làm việc/cache theo skill gọi nguồn.
- Đặt sidecar có tên/hậu tố rõ, ví dụ `.sources.md`, `.extract.txt`, `.data.csv`, `.transcript.md`, `.diagram.png`; chỉ tạo khi chúng có ích.
- Giữ trích dẫn cần thiết và danh mục tham khảo trong báo cáo. Tạo file danh mục nguồn riêng khi quá dài hoặc được yêu cầu, rồi liên kết từ báo cáo.
- Ưu tiên công cụ local. Không dùng mạng hoặc dịch vụ từ xa như fallback âm thầm; nêu rõ khi một nguồn hay bước xử lý cần kết nối.
- Trước khi giao, kiểm tra trích dẫn, liên kết, tính nhất quán và file nguồn. Với DOCX/PDF, xác minh văn bản/trang bằng công cụ local có sẵn; báo giới hạn nếu không thể xác minh.

## Nguồn

Nguyên tắc được tổng hợp từ ICMJE, EQUATOR Network và National Academies; chi tiết và liên kết nằm tại [`reporting-principles-sources.md`](reporting-principles-sources.md).
