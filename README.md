# agent-skills

> Mức tương thích phụ thuộc hệ điều hành, agent và các công cụ được từng skill yêu cầu. Xem hướng dẫn của skill trước khi chạy.

> [`README.en.md`](README.en.md)

[![skills.sh](https://skills.sh/b/tpc-pascal/agent-skills)](https://skills.sh/tpc-pascal/agent-skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Repo tổng hợp các bộ skill agent cho OpenCode/Claude/Cursor. Mỗi bộ nằm trong thư mục `skills/` ở root, tự chứa và cài riêng được. Bộ tiếp theo (nếu có) cũng thêm vào `skills/` theo cùng cách.

Bộ hiện có: [`skills/research/`](skills/research/README.md).

## Cài đặt

Mỗi bộ = một thư mục con của `skills/`; repo cài theo từng bộ, không cài cả repo — một lệnh:

```bash
# <tên-bộ> lấy theo thư mục con của skills/; thêm -g sau tên bộ = cài cấp người dùng
npx -y github:tpc-pascal/agent-skills <tên-bộ>
```

Bỏ `<tên-bộ>` để xem danh sách các bộ.

## Đóng gói bộ

Mỗi bộ có đúng một tag + một release trùng tên bộ, trỏ commit mới nhất chạm vào `skills/<tên-bộ>/`. CI tự chuyển chúng mỗi lần có commit vào `main`; chạy tay cũng được: `bash scripts/tag-release.sh <tên-bộ>`.

## Đặc điểm

- **Tự chứa, route theo tên** — mỗi bộ/skill cài độc lập, không phụ thuộc lẫn nhau.
- **Skill bên thứ ba theo phiên**: `scripts/fetch-session.sh` ghim commit-SHA, tải về thư mục tạm, không bao giờ cài vĩnh viễn vào `~/.agents/skills/`.
- **Song ngữ 100%**: mọi file `.md` đều có bản `.en.md`, `scripts/smoke.sh` + CI kiểm tra tự động.
- **Local-first**: ưu tiên CLI local cho file local; nguồn web, API và dịch vụ ngoài cần kết nối, trừ khi có cache/backend local.
- **Verify output**: kiểm tra lại bằng công cụ local trước khi giao, không bịa.

## Cấu trúc repo

```text
skills/
  <bo>/                 # một bộ skill (vd. research/) — mỗi thư mục con của skills/ là một bộ
    <skill>/            # mỗi skill một thư mục con
      SKILL.md          # skill bản Việt
      SKILL.en.md       # skill bản Anh (bắt buộc song ngữ)
      references/       # tài liệu tham khảo (tùy chọn)
scripts/                # smoke.sh, fetch-session.sh, install.sh, tag-release.sh
.github/workflows/      # CI chạy smoke + parity song ngữ
```

Trong tài liệu luồng, `▸` nghĩa là bàn giao bước; `→` nghĩa là luồng tiếp tục; dấu `[]` trong sơ đồ chú thích loại nguồn/kết quả. Ký hiệu này không thay thế nhãn nguồn trong báo cáo.

## Thêm bộ skill mới

1. Tạo thư mục mới trong `skills/` (`skills/<tên-bo>/`); mỗi skill một thư mục con có `SKILL.md` + `SKILL.en.md` (frontmatter `name`/`description`/`license`).
2. Bổ sung mô tả bộ vào `README.md` và `README.en.md`.
3. Chạy `scripts/smoke.sh` rồi mở PR.

Chi tiết đóng góp: [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

MIT — xem [LICENSE](LICENSE). Skill bên thứ ba giữ license gốc.
