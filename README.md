# claude-flow — quy trình làm việc với Claude, dùng chung cho mọi dự án

Bộ này gom lại thứ đã tự dựng rời rạc ở ba repo (`dear_embeiu`, `leadflow`, `ea-studio`) thành
**một plugin cài một lần, dùng cho mọi project — kể cả project chưa tồn tại.**

Nó giải quyết đúng một vấn đề: **ký ức của Claude không đi theo máy, cũng không đi theo phiên.**
Mở phiên mới là mất sạch — trừ những gì đã nằm trên đĩa và trong git.

## Có gì

**11 lệnh** (`/flow:<tên>`, có namespace nên không đụng lệnh sẵn có của repo):

| Lệnh | Việc |
|---|---|
| `/flow:khoi-tao` | **Bật bộ này cho một repo** — dò stack, dựng `project/`, viết `.claude/flow.json` |
| `/flow:lead` | 1 đầu mối: tự chọn lăng kính theo câu hỏi; việc nhỏ làm thẳng, feature trọn thì bật pipeline |
| `/flow:po` `/flow:designer` `/flow:dev` `/flow:tester` | Vào từng vai |
| `/flow:feature-new` | PO mở feature mới từ khuôn |
| `/flow:roadmap` | Toàn cảnh: feature nào ở pha nào, đang chờ ai |
| `/flow:done` | **PO FINAL VERIFY** — cửa cuối trước khi đóng ✅ |
| `/flow:dau-ca` `/flow:cuoi-ca` | Mở/đóng máy: đồng bộ code + env + DB, ghi lại trạng thái |

**4 agent** (`flow:po` · `flow:designer` · `flow:dev` · `flow:tester`) cho chế độ PO điều phối.
`flow:tester` **không có tool Write/Edit** — ranh giới cứng, không thể sửa code nó vừa test.

**3 hook tự chạy:**

| Hook | Khi nào | Làm gì |
|---|---|---|
| `ghi-nhat-ky.sh` | mở phiên + **mỗi câu bạn nhắn** | Ghi vào `project/USER_HISTORY.md` (được commit → máy kia đọc được) |
| `dau-phien.sh` | mở phiên | `git fetch` → tự `pull --ff-only` nếu an toàn → **nạp thẳng vào context**: N câu vừa nhờ + nợ đang mở + git log |
| `cong-chat-luong.sh` | trước khi Claude kết thúc lượt | Code đổi mà lệnh kiểm chưa sạch → **CHẶN**, bắt sửa |

> **Mọi hook tự thoát êm nếu repo không có `.claude/flow.json`** — cài plugin không làm phiền
> những repo chưa bật.

## Cài (mỗi máy một lần)

```bash
git clone <url repo này> ~/projects/claude-flow     # máy mới
```

Trong Claude Code:

```
/plugin marketplace add ~/projects/claude-flow
/plugin install flow@claude-flow
```

Cập nhật về sau: `git pull` trong repo này rồi `/reload-plugins`.

## Dùng cho một project

```
cd <repo>
claude
/flow:khoi-tao
```

Lệnh đó dò stack, dựng `project/`, viết `.claude/flow.json`, rồi commit. **Xong. Hook có hiệu
lực từ phiên mở sau đó.**

Việc còn lại của bạn — và là việc quan trọng nhất: **sửa `project/roles.md`** cho khớp dự án
(stack, quy ước, catalog rủi ro, đánh đổi có chủ ý). Khung 4 vai dùng chung được; phần kiến
thức riêng thì không ai viết hộ. `roles.md` tốt tới đâu, bộ này hữu ích tới đó.

## Thiết kế: cái gì generic, cái gì riêng

Ranh giới này là toàn bộ lý do bộ này tái dùng được:

| | Ở đâu | Ví dụ |
|---|---|---|
| **Khung** (dùng chung mọi dự án) | plugin này | 4 vai, lifecycle, Definition of Done, quy tắc orchestrator, cơ chế 3 hook |
| **Ruột** (mỗi dự án một khác) | `.claude/flow.json` + `project/roles.md` | lệnh gate, nhánh làm việc, tài liệu luật, catalog rủi ro, quyền commit/deploy |

Lệnh trong plugin **không hardcode** `npm run lint` hay tên tài liệu nào — chúng đọc
`.claude/flow.json`. Đó là lý do cùng một `/flow:dev` chạy được cho Next.js lẫn Flutter.

## `.claude/flow.json`

Xem mẫu đầy đủ kèm chú thích: [`plugins/flow/mau/flow.json`](plugins/flow/mau/flow.json).
Hai field hay khai sai:

- **`gate.lenh`** — chỉ lệnh **nhanh** (kiểu/lint/typecheck). Test nặng, e2e, build production
  để `/flow:done` gọi. Nhét vào đây là mỗi lần dừng lượt phải chờ 5 phút, rồi bạn sẽ tắt nó đi.
- **`gate.duong`** — khai hẹp. Khai cả repo thì sửa README cũng kích gate chạy.

## Lịch sử & bài học đã trả giá

Ba thứ trong bộ này sinh ra từ lỗi thật, đừng "dọn lại cho gọn":

1. **Gate băm nội dung file trên đĩa**, không băm HEAD/index/diff. Mọi cách băm theo trạng thái
   git đều đổi hash khi nội dung *di cư* unstaged→staged→committed dù không đổi một byte — băm
   HEAD thì chạy lại sau mỗi commit, băm index+diff thì chạy lại sau mỗi `git add`.
2. **`dau-phien.sh` gộp pull + nạp ngữ cảnh làm MỘT hook.** Tách hai hook trên cùng sự kiện thì
   thứ tự chạy không bảo đảm — hôm nào chạy ngược là nạp ngữ cảnh cũ rồi mới kéo code mới về.
3. **Cây làm việc bẩn thì KHÔNG tự pull**, chỉ nhắc. Thay file dưới tay người đang sửa dở là
   một loại mất dữ liệu khác.

Nhật ký tự động (`USER_HISTORY.md`) cũng vậy: nó ghi *đường đi* (đã hỏi gì, thứ tự nào), khác
với nhật ký viết tay ghi *kết luận*. Và nó là thứ duy nhất sống sót khi phiên kết thúc đột ngột
— lúc mà nhật ký tay chưa kịp viết dòng nào.
