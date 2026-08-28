---
description: Hiện portfolio tất cả feature + trạng thái hiện tại
argument-hint: [tên feature để xem chi tiết]
---
Đọc `project/ROADMAP.md` và tóm tắt gọn cho chủ dự án:

- Feature đang ở pha nào (📋/🎨/💻/🧪/✅), cái nào **đang chờ chủ dự án quyết/duyệt**.
- Nợ kỹ thuật / rủi ro nổi bật đang mở.
- Backlog kế tiếp theo ưu tiên.
- **Việc dở dang từ phiên trước:** đối chiếu đuôi nhật ký tự động (`nhatky.file` trong
  `.claude/flow.json`) + mục mới nhất của nhật ký phiên viết tay (`tailieu.nhatkyPhien`) +
  `git log --oneline -10`. Ba nguồn này trả lời ba câu khác nhau: *đã nhờ gì* · *vì sao dừng* ·
  *đã đổi gì*.

Nếu chủ dự án nêu tên feature (`$ARGUMENTS`) → đọc thêm `project/features/<tên>/roadmap.md` +
`overview.md` và báo chi tiết phase/việc còn lại của riêng nó. Tên gần đúng thì tra trong
ROADMAP.md để khớp, đừng bắt gõ lại cho chuẩn.
