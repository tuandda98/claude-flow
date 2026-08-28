# <Tên feature>

> File PO sở hữu. Nguồn sự thật chung cho cả feature — Designer/Dev/Tester đọc file này trước.
> Mâu thuẫn với tài liệu luật của dự án (`tailieu.luat`) → **tài liệu luật thắng**; muốn khác
> thì phải chủ dự án chốt + sửa tài liệu luật trước.
> Acceptance criteria phải RÕ & ĐO ĐƯỢC — PO đóng Done dựa vào đây.

- **Feature:** <ten-feature>
- **Ưu tiên:** <P0 | P1 | P2>
- **Trạng thái:** 📋 Spec
- **Tạo ngày:** <YYYY-MM-DD>
- **Liên quan:** [roadmap.md](roadmap.md) · [design.md](design.md) · [dev.md](dev.md) · [test.md](test.md)

## 1. Vấn đề & giá trị
- *Vấn đề người dùng (ai gặp, lúc nào):* <…>
- *Giả thuyết giá trị:* <nếu làm X thì Y cải thiện…>
- *Đo bằng gì:* <…>

## 2. Căn cứ
- *Mục trong tài liệu luật:* <… — hoặc "ngoài luật hiện có, chủ dự án chốt ngày …">
- *Bối cảnh/nghiên cứu:* <insight, đối thủ, chuẩn ngành — dẫn nguồn nếu có>

## 3. Phạm vi
- **Trong phạm vi:** <…>
- **Ngoài phạm vi:** <…>

## 4. Quyết định đã chốt (decision log)
> Chỉ append/gạch, **không xoá** — để biết vì sao từng chọn vậy. Đừng lật lại trừ khi chủ dự án đổi ý.
- **D1 —** <quyết định> · *Lý do:* <…>

## 5. Acceptance criteria (xong khi…)
- [ ] <tiêu chí 1 — đo được>
- [ ] Có test/kịch bản hồi quy cho luật kiểm được
- [ ] Cổng chất lượng (`gate.lenh`) sạch

## 6. Giao việc (chi tiết ở file mỗi vai)
- 🎨 **Designer:** <làm gì — hoặc "bỏ qua stage này (thuần backend)"> → *expect:* <deliverable>
- 💻 **Dev:** <làm gì> → *expect:* <deliverable + test để lại>
- 🧪 **Tester:** <phạm vi test> → *expect:* verdict PASS/FAIL trong test.md

## 7. Changelog feature
- [<YYYY-MM-DD>] [PO] Tạo feature, viết spec.
