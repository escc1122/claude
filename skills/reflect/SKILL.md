---
name: reflect
description: "回頭整理累積的教訓：讀專案 memory 裡的教訓與 feedback，對照 plugin 文件，提出新增、合併、刪除的建議。只提案、不改檔。"
argument-hint: "[可選：只看某個主題，例如「回應格式」]"
disable-model-invocation: true
---

# 回頭整理教訓

**範圍：** "$ARGUMENTS"（空白就全看）

建議頻率：每個月一次，或累積 10 張 MR 一次。單一教訓當下就回饋，這裡處理的是「單看一張看不出是同一個毛病」的東西。

## 1. 讀素材

1. **教訓**：當前專案的 auto-memory 目錄（`~/.claude/projects/<專案目錄>/memory/`，`MEMORY.md` 是索引）。讀所有 `type: feedback` 的檔案，以及各 review 紀錄裡標「教訓」「過程教訓」的段落。
2. **plugin 文件**（比對用）：
   - `${CLAUDE_PLUGIN_ROOT}/commands/review-mr.md`
   - `${CLAUDE_PLUGIN_ROOT}/skills/principles/SKILL.md`
   - `${CLAUDE_PLUGIN_ROOT}/skills/code/SKILL.md`
   - `${CLAUDE_PLUGIN_ROOT}/rules/communication.md`
3. **舊對話**：只在 memory 講不清楚某條教訓的來龍去脈時，才對 `~/.claude/projects/<專案目錄>/<session-id>.jsonl` 做 targeted grep，只抽片段，不整段載入。

## 2. 歸類

把每條教訓歸成「同一種毛病」：看根因，不看發生在哪張 MR。單看一張不像、放在一起才看得出是同一類的，正是這一步要找的。

每一類記下：出現次數、各次的出處（哪個 memory 檔、哪張 MR）、一句話講這類毛病是什麼。

## 3. 對照文件，分成五類

1. **反覆出現、文件沒寫**：建議新增。附上建議的文字，並說要放哪一層（principles＝寫與審共用／review-mr 核心原則＝review 專屬姿態／某個 Phase）。
2. **出現一次、但被標為重要或關鍵**：建議新增，同上。
3. **已經寫進文件**：列出對應的條目標題，不用動。
4. **反覆出現、但寫了也擋不住**：列出次數與試過的做法。不要硬提新機制；先查 memory 有沒有「試過、不可行」的紀錄，有就照它。
5. **只出現一次、先不寫**：留在 memory，等再出現。

另外列出：

- **過時內容**：memory 或文件裡指向舊位置、舊做法的描述。
- **重複**：同一條規則在 memory 與 plugin 文件各一份。建議哪邊留正本、哪邊改成一行指標。

## 4. 輸出

照溝通規則寫：先一段白話講這一輪最值得注意的一件事，再依上面的分類列出。每條提案附出處。

**只提案，不改任何檔案。** 使用者決定要改的，回到 plugin 的原始 repo 改（不是 `${CLAUDE_PLUGIN_ROOT}` 的安裝快取），照 repo 裡 `.claude/CLAUDE.md` 的規則：改核心原則或流程前先過 review-mr「文件維護」段的評估六問，結構性改動推上去前做對抗分析。memory 裡過時的指向可以直接修。
