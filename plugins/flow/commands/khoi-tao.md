---
description: Bật bộ quy trình cho repo hiện tại — dò stack, dựng project/, viết .claude/flow.json
argument-hint: [ghi chú thêm, vd "dùng fvm flutter", "nhánh làm việc là dev"]
---
Bật **bộ quy trình `flow`** cho repo đang mở. Tự làm hết, chỉ hỏi khi thật sự không suy ra được.

## 1. Dò hiện trạng (đọc đĩa, đừng đoán)

- Repo git chưa? nhánh làm việc mặc định là gì (`main` hay `dev`)? có remote chưa?
- Stack + **lệnh kiểm chất lượng thật sự chạy được** — đọc `package.json` (scripts), `pubspec.yaml`,
  `pyproject.toml`, `Makefile`, `Cargo.toml`… Đừng chép mặc định: dự án không có script `lint`
  thì đừng khai `npm run lint`.
- Đã có tài liệu luật/bối cảnh chưa: `CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/*`.
- Đã có sẵn `project/` hoặc `.claude/commands/` chưa (repo có thể đã dựng tay một phần —
  **giữ nguyên cái đang có**, chỉ bù phần thiếu, đừng ghi đè).

## 2. Viết `.claude/flow.json`

Đây là thứ DUY NHẤT các hook đọc — không có nó thì mọi hook tự thoát êm. Mẫu đầy đủ kèm chú
thích từng field: `${CLAUDE_PLUGIN_ROOT}/mau/flow.json`. Điền theo thứ vừa dò được:

- `gate.lenh` — mảng lệnh chạy trước khi kết thúc lượt. **Chỉ khai lệnh NHANH** (giây tới ~1
  phút): kiểu/lint/typecheck. Test nặng, e2e, build production thì để `/flow:done` gọi, đừng
  nhét vào đây — mỗi lần dừng lượt phải chờ 5 phút là bộ này thành gánh nặng.
- `gate.duong` — thư mục/file mà gate quan tâm. Hẹp thôi: khai cả repo thì sửa README cũng
  kích gate chạy.
- `tailieu.*` — trỏ tới tài liệu luật thật của repo (bỏ trống nếu chưa có).
- `nhatky` / `ngucanh` / `git` — để mặc định trừ khi có lý do.

Xong thì **tự kiểm ngay**: chạy tay đúng các lệnh trong `gate.lenh`. Lệnh sai/không tồn tại
thì sửa lại flow.json **bây giờ**, đừng để lần Stop đầu tiên mới lộ ra.

## 3. Dựng `project/`

Copy theo đúng bảng này (nguồn ở `${CLAUDE_PLUGIN_ROOT}/mau/`):

| Nguồn | Đích trong repo |
|---|---|
| `mau/flow.json` | `.claude/flow.json` *(bước 2 — xoá hết key `_` chú thích sau khi điền)* |
| `mau/README.md` | `project/README.md` |
| `mau/ROADMAP.md` | `project/ROADMAP.md` |
| `mau/roles.md` | `project/roles.md` |
| `mau/_templates/*` | `project/_templates/*` |

Rồi **sửa lại cho khớp repo này**:

- `roles.md` — thay phần persona Dev + **catalog rủi ro Tester** bằng thứ đúng với dự án
  (khuôn mẫu chỉ là chỗ trống có gợi ý). Đây là file mang KIẾN THỨC RIÊNG của dự án; các lệnh
  `/flow:*` đều đọc nó, nên nó tốt tới đâu thì bộ này hữu ích tới đó.
- `ROADMAP.md` — seed từ hiện trạng thật: cái gì đã có (baseline), cái gì đang dở, backlog.
  **Đừng tạo folder feature hồi tố** cho thứ đã xong từ lâu.

## 4. Nối vào bộ nhớ sẵn có của repo

Thêm một mục ngắn vào `CLAUDE.md`/`AGENTS.md` (tạo mới nếu chưa có): repo này dùng bộ `flow`,
`project/` là gì, các lệnh `/flow:*` có sẵn, và **những chỗ CỐ Ý khác mặc định** (vd "repo này
cho Claude commit/push", "không tự deploy prod"). Không có dòng này thì phiên sau đọc `project/`
mà không biết vì sao nó ở đó.

## 5. Dọn & chốt

- `.gitignore`: thêm `.claude/settings.local.json` (cấu hình riêng từng máy).
- Bật plugin cho repo (`.claude/settings.json` → `enabledPlugins`) nếu chưa bật ở cấp user.
- **Commit tất cả** (`project/`, `.claude/flow.json`, `.claude/settings.json`) — bộ này đi
  theo git, đó là cách máy kia có nó.
- Báo lại gọn: đã dò ra stack gì, `gate.lenh` là gì (và đã chạy thử chưa), dựng những file
  nào, còn gì cần chủ dự án tự làm.

⚠️ Hook chỉ nạp lúc mở phiên → **phiên hiện tại chưa chịu tác dụng**, nói rõ điều này khi báo.

**Ghi chú thêm từ chủ dự án:** $ARGUMENTS
