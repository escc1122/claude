#!/usr/bin/env bash
# push 前檢查：plugin 格式、元件載入。公司資訊與實際案例由 Claude 人工檢查（見 .claude/CLAUDE.md）。
# 用法：scripts/check.sh [--live]   --live 另外開一個 haiku session 確認溝通規則真的被載入
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

fail=0
ok()  { printf '  ✓ %s\n' "$1"; }
bad() { printf '  ✗ %s\n' "$1"; fail=1; }

echo "1. plugin 格式"
if out=$(claude plugin validate . 2>&1); then
  ok "validate 通過"
else
  bad "validate 失敗"; echo "$out"
fi

echo "2. 元件載入"
details=$(claude --plugin-dir "$PWD" plugin details alma 2>&1 || true)
for skill in code principles review-mr; do
  if echo "$details" | grep -q -E "Skills \([0-9]+\).*\b$skill\b"; then ok "skill $skill"; else bad "skill $skill 沒載入"; fi
done
if echo "$details" | grep -q -E 'Hooks \([1-9]'; then ok "hook 已註冊"; else bad "hook 沒註冊"; fi

if [ "${1:-}" = "--live" ]; then
  echo "3. 實際載入溝通規則（haiku）"
  answer=$(cd "$(mktemp -d)" && claude --plugin-dir "$OLDPWD" --model haiku -p \
    '這個 session 開頭有沒有收到「溝通規則」？有就只回它第一個小標題的文字，沒有就回 NONE。' 2>&1)
  if echo "$answer" | grep -q '語言'; then ok "溝通規則有載入"; else bad "溝通規則沒載入：$answer"; fi
fi

if [ $fail -eq 0 ]; then echo "全部通過"; else echo "有檢查沒過"; fi
exit $fail
