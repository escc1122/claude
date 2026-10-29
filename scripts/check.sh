#!/usr/bin/env bash
# push 前檢查：plugin 格式、公司資訊外洩、元件載入。
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

echo "2. 公司資訊外洩"
patterns=scripts/leak-patterns.local
if [ ! -s "$patterns" ]; then
  bad "找不到 $patterns（一行一個 regex，不進 git）"
else
  hits=$(git ls-files -z | xargs -0 grep -n -i -E -f "$patterns" 2>/dev/null || true)
  if [ -n "$hits" ]; then bad "檔案內容命中："; echo "$hits"; else ok "檔案內容乾淨"; fi

  upstream=$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null || echo "")
  range=${upstream:+$upstream..HEAD}
  meta=$(git log --format='%h %an <%ae> %s' ${range:-HEAD} | grep -i -E -f "$patterns" || true)
  if [ -n "$meta" ]; then bad "還沒 push 的 commit 作者或訊息命中："; echo "$meta"; else ok "commit 作者與訊息乾淨"; fi
fi

echo "3. 元件載入"
details=$(claude --plugin-dir "$PWD" plugin details alma 2>&1 || true)
for skill in code principles review-mr; do
  if echo "$details" | grep -q -E "Skills \([0-9]+\).*\b$skill\b"; then ok "skill $skill"; else bad "skill $skill 沒載入"; fi
done
if echo "$details" | grep -q -E 'Hooks \([1-9]'; then ok "hook 已註冊"; else bad "hook 沒註冊"; fi

if [ "${1:-}" = "--live" ]; then
  echo "4. 實際載入溝通規則（haiku）"
  answer=$(cd "$(mktemp -d)" && claude --plugin-dir "$OLDPWD" --model haiku -p \
    '這個 session 開頭有沒有收到「溝通規則」？有就只回它第一個小標題的文字，沒有就回 NONE。' 2>&1)
  if echo "$answer" | grep -q '語言'; then ok "溝通規則有載入"; else bad "溝通規則沒載入：$answer"; fi
fi

if [ $fail -eq 0 ]; then echo "全部通過"; else echo "有檢查沒過"; fi
exit $fail
