# 維護這個 plugin

這份只在這個 repo 裡改 plugin 時載入，不是 plugin 內容。

## push 前

- 一律跑 `scripts/check.sh`（pre-push hook 會自動跑；新 clone 要先 `git config core.hooksPath scripts/git-hooks`）。改到 hook 或 `rules/` 時加 `--live`。
- 公司字眼清單在 `scripts/leak-patterns.local`，不進 git。新 clone 沒有這份檔，檢查會失敗，要先建。

## 什麼時候加做對抗分析

做：

- 改結構：搬移或合併原則、改流程的步驟順序、新增指令或 skill。
- 新增或改寫原則內容。最容易混進「Claude 覺得對、但使用者沒說過」的東西。
- 一次改很多檔案，怕前後對不上。

不用做：改錯字、調措辭、改 README，跑完 `scripts/check.sh` 就可以推。

## 對抗分析怎麼做

1. 並行開兩個子代理：Fable 和 Sonnet，給一樣的中立材料（diff 範圍、需求目標、要對照的原始素材）。
2. 不給它們我的結論、討論過程或 memory，prompt 裡寫明「不要讀 memory 目錄或舊 session 紀錄」、「只讀不改」。
3. 要它們每點附證據（`檔案:行號`、指令輸出、文件網址＋原文），沒證據的標「推測」。
4. 回來三方對帳：兩邊都提的、只一邊提的、我不同意的分開列。每條新主張我都回檔案驗證後才採計，並明講哪些推翻了我原本的判斷。

## 結構

- `skills/principles`：寫與審共用的工程原則。其他檔案用條目標題引用，不用編號，也不重複抄內容。
- `commands/review-mr.md`：review 流程與 review 專屬姿態。改它的核心原則或流程前，照它「文件維護」段的評估六問。
- `skills/code`：寫程式流程，只能手動叫用。
- `rules/communication.md` + `hooks/hooks.json`：溝通規則，每個 session 自動載入。
- `backup/`：大改前的舊版，plugin 不載入。
