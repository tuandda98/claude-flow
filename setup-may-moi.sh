#!/usr/bin/env bash
# Dựng bộ quy trình `flow` trên MỘT MÁY MỚI (hoặc máy vừa cài lại).
#
# Chạy:  bash ~/projects/claude-flow/setup-may-moi.sh
#
# Script này KHÔNG đụng vào project nào — nó chỉ lo phần CẤP MÁY:
#   1. kiểm công cụ bắt buộc
#   2. đăng ký marketplace + cài plugin `flow`
#   3. IN RA danh sách thứ phải chuyển tay (script không tự làm được, và cũng không nên)
#
# Phần cấp PROJECT (clone repo, unlock secret, cài phụ thuộc) thì mở Claude trong repo đó rồi
# gõ `/flow:dau-ca` — nó kiểm đúng những thứ khai trong `.claude/flow.json`.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ok=0; thieu=0
say()  { printf '%s\n' "$*"; }
tick() { printf '  ✓ %s\n' "$*"; ok=$((ok+1)); }
warn() { printf '  ✗ %s\n' "$*"; thieu=$((thieu+1)); }

say ""
say "═══ 1. Công cụ bắt buộc ═══"
for c in git python3 claude; do
  if command -v "$c" >/dev/null 2>&1; then tick "$c — $(command -v $c)"; else warn "$c — CHƯA CÓ (bắt buộc)"; fi
done
# git-crypt: chỉ cần nếu có repo dùng secret mã hoá. Thiếu thì không chặn script.
if command -v git-crypt >/dev/null 2>&1; then
  tick "git-crypt — $(command -v git-crypt)"
else
  say "  · git-crypt — chưa có. Cần nếu repo của bạn commit secret dạng mã hoá:  brew install git-crypt"
fi

say ""
say "═══ 2. Cài plugin flow ═══"
if ! command -v claude >/dev/null 2>&1; then
  warn "chưa có Claude Code → bỏ qua bước này"
else
  if claude plugin marketplace add "$ROOT" 2>&1 | tail -1 | grep -qiE "success|already"; then
    tick "marketplace claude-flow"
  else
    warn "không thêm được marketplace — thử tay:  /plugin marketplace add $ROOT"
  fi
  if claude plugin install flow@claude-flow --scope user 2>&1 | tail -1 | grep -qiE "success|already"; then
    tick "plugin flow@claude-flow (scope user — dùng cho MỌI project)"
  else
    warn "không cài được plugin — thử tay:  /plugin install flow@claude-flow"
  fi
fi

say ""
say "═══ 3. Thứ KHÔNG đi theo git — phải chuyển tay từ máy kia ═══"
say "   (script cố ý không tự làm: đây là khoá bí mật, đưa qua đường an toàn của bạn)"
say ""
say "   □ Khoá git-crypt của từng repo có secret mã hoá"
say "       máy cũ:  cd <repo> && git-crypt export-key ~/khoa-<repo>.key"
say "       máy này: cd <repo> && git-crypt unlock ~/khoa-<repo>.key"
say "       ⚠ Chuyển bằng đường an toàn (AirDrop / USB), ĐỪNG gửi qua chat hay email."
say "   □ SSH key để deploy/kết nối máy chủ (nếu dự án có)"
say "   □ Toolchain riêng của từng stack: nvm/node · fvm/flutter · uv/python …"
say "   □ Đăng nhập lại: claude · vercel · supabase · gh (nếu dùng)"
say ""
say "═══ 4. Sau đó, với TỪNG project ═══"
say "   git clone <url> && cd <repo> && claude"
say "   → gõ  /flow:dau-ca      (đồng bộ + kiểm env/DB/nhánh + tóm tắt máy kia đã làm gì)"
say "   → repo chưa bật bộ này (không có .claude/flow.json) thì gõ  /flow:khoi-tao  trước"
say ""
if [ "$thieu" -gt 0 ]; then
  say "Kết: $ok mục xong, $thieu mục còn thiếu (xem dấu ✗ ở trên)."
  exit 1
fi
say "Kết: $ok mục xong. Phần cấp máy đã đủ — còn lại là mục 3 và 4 ở trên."
