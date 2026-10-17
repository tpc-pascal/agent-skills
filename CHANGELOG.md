# Lịch sử phát hành

Repo phát hành theo **collection**, không theo chuỗi phiên bản SemVer. Mỗi thư mục trong `skills/` có đúng một tag và một GitHub Release cùng tên. Tag/release đó là snapshot hiện hành của collection và được CI di chuyển tới commit mới nhất có thay đổi trong thư mục collection. Lịch sử phát triển chi tiết được lưu trong [Git log](https://github.com/tpc-pascal/agent-skills/commits/main/).

## [`research`](https://github.com/tpc-pascal/agent-skills/releases/tag/research)

Collection nghiên cứu gồm sáu skill độc lập, được phối hợp khi workflow cần nhiều bước:

- `orchestrator`: định tuyến yêu cầu tới skill phù hợp và hỏi phần yêu cầu báo cáo còn thiếu.
- `doc`: trích xuất, OCR, chuyển đổi và xác minh tài liệu bằng công cụ local khi có sẵn.
- `media`: kiểm tra và xử lý file audio/video/ảnh; thao tác URL cần mạng và skill bên thứ ba được tải theo phiên.
- `web`: đọc/tìm kiếm nguồn trực tuyến; offline chỉ xử lý nội dung local đã được cung cấp.
