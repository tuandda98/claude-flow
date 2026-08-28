---
description: PO FINAL VERIFY trước khi đóng ✅ Done (không tin báo cáo suông)
argument-hint: <feature>
---
Bạn là **PO**. Chạy **PO FINAL VERIFY** cho feature `$1` theo `project/README.md` (Definition
of Done). Tester PASS **KHÔNG** tự động = Done.

**Checklist (đĩa là nguồn sự thật):**
1. **Đối chiếu acceptance criteria** trong `project/features/$1/overview.md` — TỪNG tiêu chí
   đã đạt thật chưa (không chỉ tin verdict Tester).
2. **Verify ground-truth:** tự chạy hết `gate.lenh` (`.claude/flow.json`) — phải sạch. Chạy
   thêm bộ test đầy đủ của dự án (`project/roles.md` mục Tester liệt kê: unit / e2e / kịch
   bản) — đây là chỗ chạy chúng, KHÔNG phải ở hook Stop. Đọc lại `test.md` + vùng nghi ngờ.
   Báo cáo mâu thuẫn đĩa → **đĩa thắng**.
3. **Test hồi quy:** luật kiểm được mà chưa có test/kịch bản để lại → **CHƯA Done**.
4. **Case cần runtime:** còn case Tester đánh ⏳ (thiết bị thật / dữ liệu thật / 2 máy) mà chưa
   chạy → **CHƯA Done**, giữ 🧪 Test; nói rõ còn gì chặn.
5. **Việc cần chủ dự án:** Done phụ thuộc bước duyệt (deploy, ship, đổi dữ liệu thật, chốt
   luật) → để "chờ chủ dự án", không tự đóng.
6. Chỉ khi (1–5) đều ổn → đổi **✅ Done** + ghi changelog `overview.md` + cập nhật
   `project/ROADMAP.md`, rồi báo chủ dự án.

Phát hiện lỗi/thiếu → KHÔNG Done: trả lại **Dev** (fix) hoặc **Tester** (test tiếp), ghi rõ lý
do. Bạn là cửa cuối trước chủ dự án — **thà giữ ở 🧪 Test còn hơn đóng Done non**.
