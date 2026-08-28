---
description: Đóng máy — ghi lại trạng thái, commit và push để máy kia làm tiếp
---
Chủ dự án sắp rời máy. **Code dở nằm trên ổ cứng một máy = ca sau làm lại từ đầu.** Làm đủ,
tự chạy hết:

1. `git status --porcelain` — còn gì chưa commit, kể cả file rác cần dọn.
2. **Ghi lại trạng thái** (đây mới là phần giá trị nhất, đừng bỏ qua):
   - `project/ROADMAP.md`: trạng thái feature vừa đụng.
   - `project/features/<tên>/<vai>.md`: một dòng nhật ký `- [YYYY-MM-DD] [vai] việc đã làm`.
   - Nhật ký phiên (`tailieu.nhatkyPhien` trong `.claude/flow.json`), nếu dự án có: thêm mục
     mới ghi **đang dở tới đâu · vì sao dừng · đang chờ ai quyết gì**. Đừng chép lại thứ
     `git log` đã nói — commit trả lời "đã đổi gì", nhật ký trả lời "vì sao, và tiếp theo là gì".
   - Ca này chỉ sửa lặt vặt không thuộc feature nào → bỏ qua hai gạch đầu.
3. **Commit kể cả việc còn dở** — message ghi rõ đang làm gì và còn thiếu gì
   (`WIP: <đang làm> — còn thiếu <…>`). Nhánh + quyền commit/push theo `.claude/flow.json`
   (`git.nhanhLamViec`, `git.choPush`).
4. `git push` — không push thì mọi bước trên vô nghĩa với máy kia.
5. **Nhắc thứ KHÔNG đi theo git** mà máy kia sẽ thiếu: giá trị mới trong file env, secret vừa
   tạo, migration mới cần áp, thay đổi trên máy chủ/VM.

⚠️ Tuyệt đối **không merge sang nhánh chính và không deploy production** ở bước này, trừ khi
chủ dự án đã nói rõ.

Báo cáo: đã commit gì · còn dở gì · máy kia cần biết gì trước khi tiếp tục.
