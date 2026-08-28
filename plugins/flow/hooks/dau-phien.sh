#!/usr/bin/env bash
# SessionStart: ĐỒNG BỘ rồi NẠP NGỮ CẢNH — hai việc, một hook, đúng thứ tự.
#
# Vì sao gộp làm một thay vì hai hook: phải PULL TRƯỚC rồi mới ĐỌC FILE. Tách hai hook trên
# cùng một sự kiện thì thứ tự chạy không có gì bảo đảm, và hôm nào chạy ngược là nạp ngữ cảnh
# CŨ rồi mới kéo code mới về — sai lặng lẽ, không ai thấy.
#
# Việc 1 — đồng bộ 2 máy: fetch (trần ~8s), đứng sau origin + cây SẠCH + không diverge thì tự
# `pull --ff-only`; cây bẩn hoặc diverge thì chỉ NHẮC (thay file dưới tay người đang sửa dở là
# một loại mất dữ liệu khác); còn commit chưa push cũng nhắc.
# Việc 2 — nạp ngữ cảnh: N câu chủ dự án vừa nhờ (nhật ký tự động) + việc đang dở trong
# ROADMAP + git log gần nhất, nhét thẳng vào context của phiên.
#
# Vì sao cần việc 2: ký ức của Claude KHÔNG đi theo máy. Không có nó thì mỗi phiên mới lại
# hỏi lại thứ đã trả lời, đề xuất lại phương án đã bị loại, dựng lại rào cản đã được gỡ.
#
# TẮT/BẬT theo project qua `.claude/flow.json` (`git.tuPull`, `ngucanh.bat`). KHÔNG có file
# đó = project chưa dùng bộ này → hook im lặng thoát ngay, không đụng gì.
# LUÔN exit 0: hỏng thì kệ, không bao giờ được chặn phiên làm việc.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || true)}"
[ -n "$ROOT" ] || exit 0
CFG="$ROOT/.claude/flow.json"
[ -f "$CFG" ] || exit 0
cd "$ROOT" 2>/dev/null || exit 0

# ---------- đọc cấu hình (thiếu/hỏng thì rơi về mặc định an toàn) ----------
read_cfg() { python3 -c "
import json,sys
try: c=json.load(open('$CFG'))
except Exception: c={}
cur=c
for k in '$1'.split('.'):
    cur=cur.get(k) if isinstance(cur,dict) else None
print('' if cur is None else ('1' if cur is True else ('0' if cur is False else cur)))
" 2>/dev/null; }

TU_PULL="$(read_cfg git.tuPull)"
NGU_CANH="$(read_cfg ngucanh.bat)"
SO_CAU="$(read_cfg ngucanh.soCau)"; [ -n "$SO_CAU" ] || SO_CAU=30
FILE_NK="$(read_cfg nhatky.file)"; [ -n "$FILE_NK" ] || FILE_NK="project/USER_HISTORY.md"

SYNC_MSG=""
add_msg() { SYNC_MSG="${SYNC_MSG}$1"$'\n'; }

# ---------- VIỆC 1: đồng bộ ----------
if [ -d "$ROOT/.git" ] && [ "$TU_PULL" != "0" ]; then
  git fetch --quiet 2>/dev/null &
  fpid=$!; i=0
  while kill -0 "$fpid" 2>/dev/null && [ "$i" -lt 16 ]; do sleep 0.5; i=$((i + 1)); done
  if kill -0 "$fpid" 2>/dev/null; then
    kill "$fpid" 2>/dev/null; wait "$fpid" 2>/dev/null
    add_msg "⚠ git fetch quá 8s (mạng chậm/đứt?) — trạng thái so với origin dưới đây có thể CŨ."
  else
    wait "$fpid" 2>/dev/null || true
  fi

  upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)"
  if [ -n "$upstream" ]; then
    counts="$(git rev-list --left-right --count 'HEAD...@{upstream}' 2>/dev/null || true)"
    ahead="$(printf '%s' "$counts" | awk '{print $1}')"; behind="$(printf '%s' "$counts" | awk '{print $2}')"
    dirty="$(git status --porcelain 2>/dev/null | head -1)"
    if [ "${behind:-0}" -gt 0 ]; then
      if [ -z "$dirty" ] && [ "${ahead:-0}" -eq 0 ] && git pull --ff-only --quiet 2>/dev/null; then
        add_msg "✓ Đã tự \`git pull --ff-only\` $behind commit mới từ $upstream (cây sạch nên an toàn). FILE TRÊN ĐĨA VỪA ĐỔI — mọi thứ bạn nhớ về repo này có thể đã cũ."
      elif [ -n "$dirty" ]; then
        add_msg "⚠ Nhánh đứng SAU $upstream $behind commit nhưng cây làm việc CÒN THAY ĐỔI CHƯA COMMIT nên không tự pull. Xử lý chỗ dở (commit/stash) rồi \`git pull\` TRƯỚC khi làm tiếp — không thì đang làm trên trạng thái cũ của máy kia."
      else
        add_msg "⚠ Nhánh đứng SAU $upstream $behind commit và đã DIVERGE (có commit local chưa push). Cần rebase/merge có chủ đích — hỏi chủ dự án trước khi tự quyết."
      fi
    fi
    [ "${ahead:-0}" -gt 0 ] && add_msg "⚠ Còn $ahead commit CHƯA PUSH từ phiên trước — \`git push\` sớm kẻo máy kia mở phiên sẽ không thấy."
  fi
fi

# ---------- VIỆC 2: nạp ngữ cảnh ----------
[ "$NGU_CANH" = "0" ] && { [ -n "$SYNC_MSG" ] && printf '%s' "$SYNC_MSG"; exit 0; }

python3 - "$ROOT" "$FILE_NK" "$SO_CAU" "$SYNC_MSG" <<'PY' 2>/dev/null || { [ -n "$SYNC_MSG" ] && printf '%s' "$SYNC_MSG"; exit 0; }
import json, os, re, subprocess, sys

root, hist_rel, so_cau, sync_msg = sys.argv[1], sys.argv[2], int(sys.argv[3] or 30), sys.argv[4]
parts = []

def sh(*cmd):
    try:
        return subprocess.run(cmd, cwd=root, capture_output=True, text=True, timeout=10).stdout.strip()
    except Exception:
        return ""

if sync_msg.strip():
    parts.append("## Đồng bộ 2 máy\n" + sync_msg.strip())

# 1. Chủ dự án đã nhờ gì gần đây — bỏ nhiễu máy tự sinh.
hist = os.path.join(root, hist_rel)
if os.path.exists(hist):
    try:
        lines = open(hist, encoding="utf-8").read().splitlines()
    except Exception:
        lines = []
    asks = []
    for ln in lines:
        m = re.match(r"^- \[(\d{2}:\d{2})\] (.+)$", ln)
        if not m:
            continue
        txt = m.group(2).strip()
        if txt.startswith(("<task-notification>", "<system-reminder>", "<local-command")):
            continue
        asks.append(f"[{m.group(1)}] {txt[:200]}")
    if asks:
        parts.append(
            f"## Chủ dự án đã nhờ gì gần đây ({so_cau} câu cuối, nguồn {hist_rel})\n"
            + "\n".join(asks[-so_cau:])
        )

# 2. Việc đang dở — lấy khối "Đang làm" / "Nợ đang mở" trong ROADMAP.
road = os.path.join(root, "project", "ROADMAP.md")
if os.path.exists(road):
    try:
        txt = open(road, encoding="utf-8").read()
    except Exception:
        txt = ""
    for tieu_de in ("Đang làm", "Nợ đang mở"):
        m = re.search(r"^## " + re.escape(tieu_de) + r".*?(?=^## |\Z)", txt, re.S | re.M)
        if m and m.group(0).strip():
            parts.append(f"## {tieu_de} (nguồn project/ROADMAP.md)\n" + m.group(0).strip()[:2500])

# 3. Việc vừa làm.
log = sh("git", "log", "--oneline", "-8")
if log:
    branch = sh("git", "branch", "--show-current")
    parts.append(f"## Git — nhánh `{branch or '?'}`\n{log}")

if not parts:
    sys.exit(0)

ctx = (
    "# Ngữ cảnh tự nạp đầu phiên (plugin flow, hook dau-phien.sh)\n\n"
    "Đọc hết phần này TRƯỚC khi trả lời câu đầu tiên. Đây là việc đã diễn ra ở phiên trước "
    "và/hoặc Ở MÁY KIA — đừng hỏi lại thứ đã có câu trả lời ở đây, đừng đề xuất lại phương án "
    "đã bị loại, đừng dựng lại rào cản đã được gỡ.\n\n" + "\n\n".join(parts)
)
print(json.dumps({
    "hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": ctx},
    "suppressOutput": True,
}))
PY
exit 0
