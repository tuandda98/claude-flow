# 📁 project/ — Bộ nhớ dự án, quản lý theo feature

> Dựng bởi plugin `flow` (`/flow:khoi-tao`). Mỗi tính năng có **một folder riêng** chứa đủ
> thông tin để 4 vai (PO/Designer/Dev/Tester) dùng chung, và **mỗi vai tự ghi việc mình đã làm**.
>
> **Mục tiêu:** mở Claude ở bất kỳ máy nào, đọc folder này là biết *đang làm feature gì, tới
> đâu, ai đã làm gì* — không phải dò lại từ đầu.

## Cấu trúc

```
project/
├── README.md          ← file này (luật chơi)
├── ROADMAP.md         ← PORTFOLIO: index TẤT CẢ feature + trạng thái (cấp dự án)
├── roles.md           ← 4 vai + quy tắc orchestrator + catalog rủi ro RIÊNG dự án này
├── USER_HISTORY.md    ← nhật ký TỰ ĐỘNG (hook ghi, đừng sửa tay phần tự động)
├── _templates/        ← khuôn copy khi tạo feature mới
└── features/<tên>/    ← overview+roadmap (PO) · design (Designer) · dev (Dev) · test (Tester)
```

**Hai cấp roadmap:** `ROADMAP.md` = toàn cảnh mọi feature · `features/<tên>/roadmap.md` = phase
Now/Next/Later bên trong một feature.

**Bốn loại nhật ký, đừng gộp** — chúng trả lời bốn câu khác nhau:

| File | Trả lời | Ai ghi |
|---|---|---|
| `USER_HISTORY.md` | *chủ dự án đã nhờ gì, theo thứ tự nào* | hook, tự động |
| nhật ký phiên (nếu dự án có) | *đang dở tới đâu, vì sao dừng, chờ ai quyết* | Claude, cuối phiên |
| `features/<tên>/*.md` | *feature này đã làm gì, quyết gì* | từng vai |
| `git log` | *đã đổi những dòng code nào* | commit |

## Ai ghi file nào

| File | Vai sở hữu | Nội dung |
|------|-----------|----------|
| `overview.md` | **PO** | Vấn đề, giá trị, phạm vi, **decision log**, acceptance criteria, changelog |
| `roadmap.md` | **PO** | Phase Now/Next/Later, mốc đã đạt, phụ thuộc |
| `design.md` | **Designer** | Design spec/handoff + nhật ký design |
| `dev.md` | **Dev** | Kế hoạch kỹ thuật, file/hàm đụng tới, nhật ký implement |
| `test.md` | **Tester** | Kế hoạch test, verdict PASS/FAIL, bug report |

**Ranh giới vai (bất biến):** chỉ **Dev** sửa code. PO/Designer/Tester không. Mỗi vai chỉ ghi
file của mình. Chi tiết + đường được sửa: [`roles.md`](roles.md).

## Lifecycle

`📋 Spec` → `🎨 Design` → `💻 Dev` → `🧪 Test` → `✅ Done` (hoặc `⏸️ Paused`, `❌ Dropped`)

1. **PO** `/flow:feature-new` → folder + `overview.md` + dòng trong `ROADMAP.md`
2. **Designer** `/flow:designer <tên>` → `design.md` *(việc thuần backend không cần UI thì bỏ
   qua — PO ghi rõ trong overview)*
3. **Dev** `/flow:dev <tên>` → code + `dev.md` + test hồi quy
4. **Tester** `/flow:tester <tên>` → `test.md` + verdict. FAIL → trả về Dev
5. **PO** `/flow:done <tên>` → PO FINAL VERIFY → `✅ Done`

## Hai mode vận hành

**🟦 Mode 1 — PO Orchestrator (mặc định):** chủ dự án chỉ nói chuyện với PO (hoặc `/flow:lead`).
PO tự spawn subagent Designer/Dev/Tester **tuần tự**, gate verify giữa mỗi stage, chỉ hỏi khi
vượt thẩm quyền. Quy tắc thực thi đầy đủ: [`roles.md`](roles.md).

**🟩 Mode 2 — tự điều phối:** chủ dự án tự gắn từng vai (`/flow:dev`, `/flow:tester`…), có thể
mỗi vai một tab. Các tab KHÔNG chia sẻ trí nhớ — chúng nói chuyện qua **file trên đĩa**:

> **① Đầu lượt đọc đĩa** (Designer đọc overview · Dev đọc overview+design · Tester đọc cả 3 ·
> PO đọc cả folder). Đừng dựa vào trí nhớ của tab — tab khác có thể đã sửa.
> **② Ghi vào đúng file của mình**, nhật ký `- [YYYY-MM-DD] [vai] <việc>`.
> **③ Kết bằng câu bàn giao:** *"✅ [Vai] đã xong [feature]. Đã cập nhật `<file>`. → Chuyển sang
> **[Vai kế]**, đọc `<file>`."*

## Ai quyết định "Done"

| Cấp | Ai quyết | Căn cứ |
|-----|----------|--------|
| Xong phần của mình | Chính vai đó | Tick task + nhật ký. Đây là "giao nộp", CHƯA phải Done |
| Đạt chất lượng | **Tester** | Chạy hết case → verdict. FAIL → trả về Dev |
| Feature DONE | **PO** | Đối chiếu acceptance criteria trong `overview.md` |
| Duyệt release/deploy | **Chủ dự án** | PO đề xuất; quyết định cuối là của chủ dự án |

**🔒 PO FINAL VERIFY — Tester PASS KHÔNG tự động = Done.** Checklist đầy đủ: `/flow:done`.

**Nguyên tắc chống "tự khen":** Dev không tự tuyên bố done (chỉ *"đã implement, sẵn sàng
test"*) · Tester gác chất lượng nhưng không quyết "đủ giá trị chưa" (việc PO) · PO chốt theo
acceptance viết sẵn, không cảm tính · chủ dự án phủ quyết cao nhất. **Vì Claude đóng cả bốn
vai:** ở vai Tester phải nghiêm khắc với code chính mình vừa viết ở vai Dev — FAIL thẳng.

## Quy tắc tự động cập nhật

- Làm gì liên quan feature đã có folder → **tự cập nhật** file tương ứng + `ROADMAP.md`, không
  cần nhắc.
- Roadmap là **sổ sống, không xoá lịch sử**: việc xong → tick + chuyển "Mốc đã đạt" · việc bỏ →
  `❌ Dropped` + lý do · quyết định đổi → gạch cái cũ, ghi cái mới (decision log chỉ append).
- Ý tưởng lệch hẳn scope → **tách feature mới**, đừng nhồi vào roadmap cũ.
