---
description: Mở máy — đồng bộ code/DB/env, tóm tắt máy kia đã làm gì
---
Chủ dự án vừa mở máy (có thể là **máy còn lại** trong hai máy). Làm đủ các bước, **tự chạy
hết, đừng hỏi từng bước**, rồi báo cáo gọn.

> Hook `dau-phien.sh` đã tự fetch/pull và nạp ngữ cảnh ở đầu phiên. Lệnh này là bản KỸ hơn:
> nó kiểm cả những thứ **không đi theo git** — thứ mà hook không thể tự biết.

1. **Code:** `git fetch --all --prune && git status -sb`. Đang ở nhánh sai so với quy ước dự
   án (`git.nhanhLamViec` trong `.claude/flow.json`) thì chuyển về đúng nhánh, rồi `git pull`.
2. **Phụ thuộc:** lockfile đổi so với lần cài gần nhất → cài lại (`npm install` /
   `pub get` / `uv sync`… theo stack).
3. **Máy kia đã làm gì:** đọc `git log --oneline -10` + đuôi nhật ký tự động
   (`nhatky.file`) + mục mới nhất của nhật ký phiên (`tailieu.nhatkyPhien`) rồi **tóm tắt**.
   Bạn KHÔNG có ký ức về phiên ở máy đó — ba nguồn này là toàn bộ những gì còn lại.
4. **Việc đang dở:** `project/ROADMAP.md` + folder feature của nó.
5. **Thứ KHÔNG đi theo git** — chỗ hay cắn nhất, kiểm riêng theo `.claude/flow.json`
   (`ngoaiGit`): file env/secret (đã unlock chưa? đang trỏ DB dev hay prod?), migration đã áp
   lên DB chưa, SSH key, khoá git-crypt, dịch vụ chạy nền. Thiếu thì **nhắc chuyển tay từ máy
   kia**, đừng cố dựng lại từ đầu.

Báo cáo: máy kia đã làm gì · việc đang dở · **có gì lệch cần xử lý trước khi làm tiếp**.
