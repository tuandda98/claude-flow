# 🧪 Test — <Tên feature>

> Tester sở hữu. Đọc `overview.md` + `design.md` + `dev.md` + catalog rủi ro (`../../roles.md`).
> CHỈ test, KHÔNG sửa code. Output: PASS hoặc FAIL kèm bug report.
> Đây là **sổ nghiệm thu** — test hồi quy sống nằm trong bộ test của dự án (việc Dev để lại).

- **Trạng thái test:** <chưa test | đang test | PASS | FAIL>

## Phạm vi test
<feature/case nào>

## Test case
| # | Loại | Mô tả | Kỳ vọng | Cách kiểm | Kết quả |
|---|------|-------|---------|-----------|---------|
| 1 | happy | <…> | <…> | <lệnh/thao tác> | ⬜ |
| 2 | edge / race | <…> | <…> | <…> | ⬜ |
| 3 | phân quyền | <…> | <…> | <…> | ⬜ |
| 4 | bảo mật / dữ liệu cá nhân | <…> | <…> | <…> | ⬜ |
| 5 | hai nhánh khác nhau (online/offline, server/client) | <…> | <…> | <…> | ⬜ |

*(Kết quả: ✅ pass · ❌ fail · ⬜ chưa chạy — ghi kèm [VERIFIED] hay [CẦN RUNTIME])*

## Bug report (nếu FAIL)
### BUG-1: <tiêu đề>
- **Severity:** <critical | major | minor>
- **File/màn hình:** <file:line hoặc route>
- **Expected:** <…>
- **Actual:** <…>
- **Steps to reproduce:** 1) … 2) … (ghi vai đăng nhập + dữ liệu nếu liên quan)

## Nhật ký test
- [<YYYY-MM-DD>] [Tester] <đã test gì / kết quả>
