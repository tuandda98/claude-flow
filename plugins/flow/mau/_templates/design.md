# 🎨 Design — <Tên feature>

> Designer sở hữu. Đọc `overview.md` trước. CHỈ thiết kế, không code. Bám hệ thiết kế của dự
> án (`../../roles.md` mục Designer trỏ chỗ) — **tái dùng token/component có sẵn, không bịa mới**.

- **Trạng thái design:** <chưa bắt đầu | đang làm | xong>

## Mục tiêu thiết kế
<màn này trả lời câu gì, cho ai>

## User flow
<các bước / sơ đồ>

## Wireframe (ASCII hoặc mô tả)
```
<layout>
```

## Spec chi tiết (token chính xác)
- Màu/spacing/radius/typography theo token có sẵn; component dùng lại cái nào. Cần token mới →
  ghi rõ **đề xuất bổ sung**, Dev là người áp vào code.

## States
- Empty (**phân biệt rỗng-vì-lọc vs rỗng-vì-chưa-có-gì**) / Loading / Error / Success /
  Disabled: <mô tả từng cái>

## Interaction
- <duration + curve; mọi nút chạy server phải có trạng thái chờ>

## Copy
| Chữ | Nhà của nó |
|-----|-----------|
| <…> | <viết thẳng tại chỗ / hằng số ở …> |

## Handoff / Dev notes
<dữ liệu lấy từ đâu; đặt `data-slot`/testid gì để test bám vào>

## Acceptance (design)
- [ ] Mọi state có mô tả
- [ ] Copy đủ, đúng nhà
- [ ] Dev dựng được không cần hỏi lại

## Nhật ký design
- [<YYYY-MM-DD>] [Designer] <đã thiết kế gì>
