# alma

我自己寫程式和 code review 用的 Claude Code plugin。寫和審用同一套原則：review 時抓的問題，寫的時候就先避開。

## 安裝

```
/plugin marketplace add escc1122/claude
/plugin install alma@escc1122
```

安裝時選 user scope，所有專案都能用。裝完開一個新 session 才會生效。

如果專案裡還有舊的 `.claude/commands/alma/review-mr.md`，請移走。它跟 plugin 的 `/alma:review-mr` 同名，會分不清叫到哪一份。

## 更新

第三方 marketplace 預設不自動更新，要手動跑：

```bash
claude plugin update alma@escc1122
```

plugin 沒寫死版號，每次更新都會拿到最新的 commit。也可以在 `/plugin` 的 marketplaces 分頁替 `escc1122` 開啟自動更新。

## 內容

- `/alma:code <任務>`：寫程式，需求 → 設計 → 實作 → 驗證。只能手動叫用，模型不會自己觸發。
- `/alma:review-mr <MR 編號>`：review 一張 GitLab MR，從需求推、先討論設計再看 bug。
- `/alma:reflect [主題]`：回頭整理累積的教訓。讀專案 memory 的教訓與 feedback，對照 plugin 文件，提出新增、合併、刪除的建議，只提案不改檔。建議每月或每 10 張 MR 跑一次。只能手動叫用。
- `alma:principles`：上面兩個共用的工程原則。兩個指令開始時都會先載入它，review-mr 只放 review 專屬的部分。
- 溝通規則（`rules/communication.md`）：每個 session 開始時由 hook 自動載入，新 session、`/clear`、壓縮後都會。
- `backup/`：大改前的舊版 review-mr，plugin 不會載入。

## 成本

- 每個 session 固定多佔約 130 token（指令與 skill 的說明）加上溝通規則約 800 字。
- 叫用時才載入的部分：review-mr 約 9.5k token、principles 約 1.9k、code 約 0.7k。

## 設定

### GitLab（review-mr 用）

建議寫在專案的 `.claude/settings.local.json`，不會進 git：

```json
{
  "env": {
    "GITLAB_URL": "https://gitlab.example.com",
    "GITLAB_PROJECT_ID": "123"
  }
}
```

也可以用 shell 的 `export`。發 comment 的 token 從 `git credential fill` 取，取不到再讀 `GITLAB_TOKEN`。兩個環境變數都沒設時，它會去查 Claude Code 替這個專案記的 auto-memory（`MEMORY.md`），再沒有就直接問你。

### 溝通規則

裝好就生效，不用另外設定。hook 沒辦法單獨關掉，不想要就在 `/plugin` 停用整個 plugin。想改內容的話，fork 這個 repo 改 `rules/communication.md`，不要改安裝後的快取，下次更新會被蓋掉。

## 適用範圍

- 全部用繁體中文。
- `review-mr` 綁 GitLab；讀需求那步預設有 Jira，沒有也能跑，只是目標會標成推測。

## 維護

給改這個 repo 的人：

- 在 repo 裡開 Claude Code 會自動載入 `.claude/CLAUDE.md`，裡面有 push 前要檢查什麼、什麼時候要做多模型對抗分析。
- `scripts/check.sh` 檢查 plugin 格式和元件載入，加 `--live` 會另外確認溝通規則真的被載入。
- 啟用 push 前自動檢查：`git config core.hooksPath scripts/git-hooks`。

## License

MIT
