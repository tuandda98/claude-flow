#!/usr/bin/env bash
# SessionStart + UserPromptSubmit: GHI NHẬT KÝ TỰ ĐỘNG — mốc mở phiên + từng câu chủ dự án nhắn.
#
# Vì sao cần dù đã có nhật ký viết tay cuối phiên: nhật ký tay ghi KẾT LUẬN ("đã làm gì, vì sao
# dừng"), còn file này ghi ĐƯỜNG ĐI ("chủ dự án đã hỏi gì, theo thứ tự nào"). Hai thứ khác nhau,
# và cái thứ hai không ai chép tay nổi. Nó cũng là thứ duy nhất sống sót khi một phiên kết thúc
# đột ngột — máy sập, đóng nhầm tab, hết pin — lúc mà nhật ký tay chưa kịp viết dòng nào.
#
# Đích: file khai ở `.claude/flow.json` (`nhatky.file`, mặc định project/USER_HISTORY.md).
# File này ĐƯỢC COMMIT — đó là cách máy kia đọc được việc máy này vừa nhờ làm gì.
#
# KHÔNG có `.claude/flow.json` = project chưa dùng bộ này → thoát ngay, không tạo file gì.
# LUÔN exit 0: nhật ký hỏng thì kệ, không bao giờ được chặn phiên làm việc.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || true)}"
[ -n "$ROOT" ] || exit 0
CFG="$ROOT/.claude/flow.json"
[ -f "$CFG" ] || exit 0

BAT="$(python3 -c "
import json
try: c=json.load(open('$CFG')).get('nhatky') or {}
except Exception: c={}
print('0' if c.get('bat') is False else '1')
" 2>/dev/null)"
[ "$BAT" = "0" ] && exit 0

REL="$(python3 -c "
import json
try: c=json.load(open('$CFG')).get('nhatky') or {}
except Exception: c={}
print(c.get('file') or 'project/USER_HISTORY.md')
" 2>/dev/null)"
[ -n "$REL" ] || REL="project/USER_HISTORY.md"
LOG="$ROOT/$REL"

INPUT=$(cat 2>/dev/null || true)
[ -n "$INPUT" ] || exit 0

mkdir -p "$(dirname "$LOG")" 2>/dev/null || exit 0
if [ ! -f "$LOG" ]; then
  printf '# Nhật ký làm việc (tự động)\n\nHook `flow:ghi-nhat-ky.sh` tự ghi: mốc mở phiên + từng câu chủ dự án nhắn.\nFile này ĐƯỢC COMMIT — máy kia đọc để biết máy này vừa nhờ làm gì.\n\nĐừng sửa tay phần tự động. Muốn ghi KẾT QUẢ một việc lớn thì thêm dòng bắt đầu bằng `> ` ngay dưới câu tương ứng.\n' > "$LOG"
fi

STAMP=$(TZ="${TZ:-Asia/Ho_Chi_Minh}" date '+%Y-%m-%d %H:%M')
TIME=$(TZ="${TZ:-Asia/Ho_Chi_Minh}" date '+%H:%M')
BRANCH=$(git -C "$ROOT" branch --show-current 2>/dev/null || echo '?')

printf '%s' "$INPUT" | python3 -c '
import json, sys
log, stamp, time_, branch = sys.argv[1:5]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)

event = data.get("hook_event_name", "")
if event == "SessionStart":
    line = "\n## Phiên mới — %s (nhánh `%s`, %s)\n" % (stamp, branch, data.get("source", "?"))
elif event == "UserPromptSubmit":
    prompt = " ".join(str(data.get("prompt", "")).split())
    if not prompt:
        sys.exit(0)
    if len(prompt) > 600:
        prompt = prompt[:600] + "…"
    line = "- [%s] %s\n" % (time_, prompt)
else:
    sys.exit(0)

with open(log, "a", encoding="utf-8") as f:
    f.write(line)
' "$LOG" "$STAMP" "$TIME" "$BRANCH" 2>/dev/null

exit 0
