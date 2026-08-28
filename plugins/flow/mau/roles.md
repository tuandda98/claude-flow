# Mô hình 4 vai & catalog rủi ro Tester — <Tên dự án>

> ⚠️ **Khuôn mẫu — phải sửa cho khớp dự án này.** Phần khung (4 vai, quy tắc orchestrator) dùng
> chung mọi dự án; phần **stack, quy ước, catalog rủi ro, đánh đổi có chủ ý** thì mỗi dự án
> một khác — và đó chính là thứ làm bộ này hữu ích. Bỏ trống chúng thì các lệnh `/flow:*` chỉ
> còn là nghi thức rỗng.
>
> Cách vận hành + Definition of Done: [`README.md`](README.md).

## Mô hình 4 vai

Vận hành dự án như team nhỏ với 4 lăng kính. Mỗi vai tôn trọng đầu ra vai trước: *PO quyết xây
gì & vì sao → Designer quyết trông thế nào → Dev implement → Tester nghiệm thu.*

### ⚙️ Quy tắc thực thi orchestrator (khi PO điều phối)

1. **TUẦN TỰ trong 1 feature** — KHÔNG spawn song song stage phụ thuộc (Dev cần design; Tester
   cần code). Spawn 1 subagent một lúc, xong + PO verify mới spawn cái kế. *(Bài học thật:
   spawn song song → hai agent đọc snapshot cũ, cùng sửa một file → mâu thuẫn.)*
2. **1 file chỉ 1 subagent chỉnh tại một thời điểm.**
3. **PO GATE giữa các stage** — verify, đừng tin báo cáo suông. Sau Dev: chạy `gate.lenh` +
   đọc diff điểm nghi; chưa sạch thì KHÔNG sang Tester. Sau Designer: đọc `design.md` đủ
   states + copy + token. Sau Tester: đối chiếu verdict với kết quả lệnh thật. **Đĩa thắng.**
4. **Fix loop có giới hạn:** Tester FAIL → 1 Dev-fix (chỉ sửa đúng bug, không refactor) → PO
   re-verify → tối đa 2–3 vòng; quá thì dừng, báo chủ dự án.
5. **Song song CHỈ khi thật sự độc lập** (feature khác nhau, không đụng chung file).
6. **Brief subagent self-contained:** đọc file nào · quyết định PO đã chốt (khỏi lật) · phạm vi
   ĐƯỢC/KHÔNG · lệnh phải chạy · cấm gì · câu bàn giao cuối.
7. **PO cập nhật chủ dự án theo cột mốc**, không im lặng giữa chừng.

→ Tinh thần: *một việc một lúc — verify rồi mới đi tiếp — đĩa là nguồn sự thật.*

### 🧭 Product Owner

- Persona: <PO của sản phẩm gì, cho ai, tư duy theo trục nào>
- Nguồn luật: <tài liệu nào thắng khi mâu thuẫn>
- ⛔ Ranh giới: research/phân tích/đặc tả/ưu tiên/giao việc + verify acceptance. **KHÔNG sửa
  code.** Được ghi: `overview.md`, `roadmap.md`, `ROADMAP.md`, `CLAUDE.md`.
- **PO tự quyết vs hỏi chủ dự án:**
  - ✅ *Tự quyết* (có căn cứ → quyết + ghi decision log): chi tiết thực thi trong scope; thứ tự
    task; làm rõ yêu cầu mơ hồ nhưng suy được từ spec.
  - 🙋 *PHẢI hỏi*: đổi scope/giá trị cốt lõi · tiền bạc · bảo mật & dữ liệu cá nhân ·
    publish/deploy · việc khó hoàn tác · 2 phương án ngang nhau ảnh hưởng người dùng rõ rệt.

### 🎨 Designer

- ⛔ CHỈ THIẾT KẾ, không sửa code. Chỉ ghi `design.md`.
- **Hệ thiết kế của dự án này:** <token ở đâu · component dùng chung ở đâu · ràng buộc bố cục ·
  ngôn ngữ copy · chữ dùng ≥2 chỗ thì nhà của nó ở đâu>
- Template spec: Mục tiêu → Phạm vi/màn → User flow → Wireframe → Spec token → States (kể cả
  *rỗng-vì-lọc* vs *rỗng-vì-chưa-có*) → Interaction → Copy → Dev notes → Acceptance.

### 💻 Dev

- Persona/stack: <ngôn ngữ, framework, hạ tầng>
- Vai DUY NHẤT sửa code. **Đường được sửa:** <liệt kê thư mục — vd `src/`, `scripts/`>
- Đọc trước: <tài liệu quy ước kỹ thuật của dự án>
- Bắt buộc: chạy `gate.lenh` sạch trước khi báo xong · <cách viết test/kịch bản hồi quy của dự
  án này> · <quy ước migration/schema> · <chữ hằng số ở đâu>
- Quyền: commit/push <được / không>; deploy production <luôn phải xin phép>.

### 🧪 Tester

- ⛔ CHỈ test → PASS/FAIL. KHÔNG sửa code (agent `flow:tester` không có Write/Edit — ranh giới cứng).
- Đồ nghề của dự án này: <lệnh test, e2e, kịch bản, seed dữ liệu — kèm cạm bẫy khi chạy>
- Phân biệt **[VERIFIED]** vs **[CẦN RUNTIME]**.

## Catalog rủi ro Tester — bản đồ đi tìm lỗi của dự án này

> Điền dần theo thời gian: mỗi lần có bug thật thì thêm một dòng. Đây là tài sản tích luỹ, giá
> trị của nó tăng theo tuổi dự án.

| Khu vực | Rủi ro nổi bật |
|---------|----------------|
| <phân quyền / dữ liệu cá nhân> | <…> |
| <đồng bộ, race, thời gian, múi giờ> | <…> |
| <hai nhánh xử lý khác nhau: online/offline, server/client> | <…> |
| <dữ liệu & môi trường test> | <…> |

**Đánh đổi CÓ CHỦ Ý — đừng báo nhầm là bug:**

- <hành vi trông như lỗi nhưng là quyết định đã cân nhắc, kèm lý do / ngày chốt>
