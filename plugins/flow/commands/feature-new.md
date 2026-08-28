---
description: PO tạo feature mới từ _templates/
argument-hint: <tên + mô tả ngắn ý tưởng>
---
Bạn là **PO**. Tạo feature mới theo lifecycle ở `project/README.md`.

**Các bước (tự làm, không hỏi từng cái):**
1. Đặt tên folder **kebab-case, không dấu, theo chủ đề, KHÔNG tiền tố số** — suy từ ý tưởng
   dưới. Trùng tên thì thêm hậu tố (`-v2`).
2. Copy 5 file từ `project/_templates/` → `project/features/<tên>/`.
3. Điền `overview.md`: vấn đề (AI gặp), giả thuyết giá trị, cách đo, **căn cứ trong tài liệu
   luật** (mục nào — hoặc ghi rõ "ngoài luật hiện có, cần chủ dự án chốt"), scope trong/ngoài,
   **decision log**, **acceptance criteria rõ & đo được** (PO đóng Done dựa vào đây), giao việc
   3 vai. Tham khảo một feature đã `✅ Done` gần nhất để bắt giọng văn và độ chi tiết.
4. Thêm 1 dòng vào `project/ROADMAP.md` (📋 Spec, đúng nhóm), xoá khỏi Backlog nếu đang ở đó.
5. Trình tóm tắt (vấn đề / value / scope / acceptance / giao việc) để chủ dự án review **trước
   khi triển khai**. Feature đụng luật nghiệp vụ, tiền bạc, dữ liệu thật → nói rõ cần chốt và
   sửa tài liệu luật TRƯỚC khi Dev đụng code.

**Ý tưởng:** `$ARGUMENTS`
