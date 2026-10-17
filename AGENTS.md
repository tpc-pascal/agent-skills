# AGENTS.md

> Bản tiếng Anh: [`AGENTS.en.md`](AGENTS.en.md)

Repo tổng hợp các bộ skill agent. Mỗi bộ nằm trong `skills/` ở root, tự chứa, cài riêng được. Quy ước khi làm việc trong repo:

## Cấu trúc

- Mỗi bộ nằm ở `<bo>/`, mỗi skill trong bộ có `SKILL.md` (VI) + `SKILL.en.md` (EN) bắt buộc song ngữ; `references/` (nếu có) cũng phải có bản `.en.md`.
- Danh sách skill của từng bộ và cách cài: xem `README.md` của bộ tương ứng (ví dụ [`skills/research/README.md`](skills/research/README.md)).
- Bắt buộc: mọi bộ skill mới phải nằm trong `skills/<bộ>/<skill>/` — không đặt bộ nào ở root. `scripts/smoke.sh` fail nếu thấy `SKILL.md` ngoài `skills/`.

## Song ngữ

- Mọi `*.md` phải có bản `*.en.md` đối ứng (trừ các file gốc như `LICENSE`, `.gitignore`). CI kiểm parity và fail nếu thiếu.
- `name:` trong frontmatter của hai bản phải giống nhau.

## Skill bên thứ ba

- Nạp theo phiên, không cài vĩnh viễn vào `~/.agents/skills/`. Dùng `scripts/fetch-session.sh`:

```bash
./scripts/fetch-session.sh --list
./scripts/fetch-session.sh --skill <tên-skill>
./scripts/fetch-session.sh --all <commit-SHA>
```

- Không commit file tải về; chỉ ghim URL + commit-SHA trong skill.

## Local-first

- Ưu tiên xử lý file local bằng công cụ local; yêu cầu CLI, model và dữ liệu đã cài/cache phải được nêu rõ.
- URL, search, API, tải skill bên thứ ba và dịch vụ render ngoài cần mạng. Không mô tả chúng là offline-capable nếu repo không có cache/backend local thực tế.
- Không gửi input lên dịch vụ ngoài qua fallback tự động. Backend mạng phải được chọn rõ và phụ thuộc đó phải được báo cho người dùng.

## Kiểm tra

- Chạy `./scripts/smoke.sh` trước khi commit/PR: hợp lệ frontmatter, parity song ngữ, quét secret, kiểm script.
