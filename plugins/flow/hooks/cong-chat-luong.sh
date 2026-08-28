#!/usr/bin/env bash
# Stop hook: CỔNG CHẤT LƯỢNG — code đổi mà lệnh kiểm chưa sạch thì CHẶN kết thúc lượt.
#
# Vì sao là hook chứ không phải một dòng luật trong CLAUDE.md: luật chỉ có hiệu lực khi model
# nhớ ra nó. Hook thì chạy bất kể model nhớ hay quên, bất kể permission mode. Đây là chỗ duy
# nhất trong bộ này ÉP được "phải sạch trước khi báo xong".
#
# Lệnh chạy do PROJECT khai ở `.claude/flow.json` (`gate.lenh`) — bộ này không đoán stack:
#   Next.js  → ["npx tsc --noEmit", "npm run lint"]
#   Flutter  → ["fvm flutter analyze"]
#   Python   → ["ruff check .", "mypy ."]
# Không khai `gate.lenh` (hoặc không có flow.json) → hook im lặng thoát, không chặn gì.
#
# "Chỉ chạy khi THẬT SỰ đổi": băm NỘI DUNG FILE TRÊN ĐĨA của các đường khai ở `gate.duong`,
# so với hash lần PASS gần nhất. Bằng nhau → thoát tức thì (phiên thuần tài liệu không phải
# chờ giây nào).
#
# ⚠️ Băm nội dung trên đĩa, KHÔNG băm HEAD/index/diff. Mọi cách băm theo trạng thái git đều
# đổi hash khi nội dung DI CƯ giữa các vế (unstaged → staged → committed) dù không đổi một
# byte nào: băm HEAD thì chạy lại sau mỗi commit, băm index+diff thì chạy lại sau mỗi
# `git add`. Đĩa chỉ đổi khi code thật sự đổi. (Đã trả giá hai lần để rút ra điều này.)
#
# Exit: 0 = ok/bỏ qua · 2 = ĐỎ (chặn Stop, feedback cho Claude sửa).
# KHÔNG set -e: hook chỉ được chặn CÓ CHỦ ĐÍCH qua exit 2.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || true)}"
[ -n "$ROOT" ] || exit 0
CFG="$ROOT/.claude/flow.json"
[ -f "$CFG" ] || exit 0
cd "$ROOT" 2>/dev/null || exit 0

# ---------- cấu hình ----------
LENH="$(python3 -c "
import json
try: g=json.load(open('$CFG')).get('gate') or {}
except Exception: g={}
print('\n'.join(g.get('lenh') or []))
" 2>/dev/null)"
[ -n "$LENH" ] || exit 0   # không khai lệnh nào = project không dùng cổng này

DUONG="$(python3 -c "
import json
try: g=json.load(open('$CFG')).get('gate') or {}
except Exception: g={}
print('\n'.join(g.get('duong') or ['.']))
" 2>/dev/null)"
[ -n "$DUONG" ] || DUONG="."

input="$(cat 2>/dev/null || true)"
active="$(printf '%s' "$input" | python3 -c "
import json,sys
try: print('1' if json.load(sys.stdin).get('stop_hook_active') else '0')
except Exception: print('0')
" 2>/dev/null || echo 0)"

# ---------- hash nội dung trên đĩa ----------
sha() { if command -v shasum >/dev/null 2>&1; then shasum -a 256; else sha256sum; fi; }
# bash 3.2 (mặc định trên macOS) không có `mapfile` — dựng mảng bằng vòng lặp cho chắc.
PATHS=()
while IFS= read -r p; do [ -n "$p" ] && PATHS+=("$p"); done <<< "$DUONG"
[ ${#PATHS[@]} -gt 0 ] || PATHS=(".")
cur="$(
  git -C "$ROOT" ls-files --cached --others --exclude-standard -- "${PATHS[@]}" 2>/dev/null |
    LC_ALL=C sort -u | while IFS= read -r f; do
      printf '%s\0' "$f"
      cat "$ROOT/$f" 2>/dev/null
    done | sha | awk '{print $1}'
)"
[ -n "$cur" ] || exit 0   # không phải repo git / không có file nào khớp → không gác

# Cache trong `.git/`: luôn tồn tại với repo git, KHÔNG BAO GIỜ bị commit, và tự biến mất khi
# repo bị xoá. Để trong `.claude/` thì có ngày lọt vào một commit "add ." nào đó.
cache_dir="$ROOT/.git/claude-flow"
cache="$cache_dir/gate.hash"
log="$cache_dir/gate.log"
[ "$cur" = "$(cat "$cache" 2>/dev/null || echo "")" ] && exit 0

# ---------- chạy các lệnh ----------
mkdir -p "$cache_dir" 2>/dev/null
: > "$log"
rc=0
while IFS= read -r cmd; do
  [ -n "$cmd" ] || continue
  echo "== $cmd ==" >> "$log"
  if ! bash -lc "cd '$ROOT' && $cmd" >> "$log" 2>&1; then rc=1; break; fi
done <<< "$LENH"

if [ "$rc" -eq 0 ]; then
  printf '%s' "$cur" > "$cache"
  exit 0
fi

if [ "$active" = "1" ]; then
  # Đã ở trong vòng continuation → không chặn lại (tránh loop vô hạn).
  echo "⚠ Cổng chất lượng VẪN đỏ (xem $log)." >&2
  exit 0
fi

{
  echo "✗ CỔNG CHẤT LƯỢNG ĐỎ — code đã đổi mà lệnh kiểm chưa sạch."
  echo "  Lệnh khai ở .claude/flow.json → gate.lenh. Log đầy đủ: $log"
  echo "  --- đuôi log ---"
  tail -30 "$log"
} >&2
exit 2
