# alma

我自己寫程式和 code review 用的 Claude Code plugin。寫和審用同一套原則：review 時抓的問題，寫的時候就先避開。

## 安裝

```
/plugin marketplace add escc1122/claude
/plugin install alma@escc1122
```

第三方 marketplace 預設不自動更新。手動更新：`claude plugin update alma@escc1122`。plugin 沒寫死版號，每次更新會拿到最新的 commit。

## 內容

- `/alma:code <任務>`：寫程式，需求 → 設計 → 實作 → 驗證
- `/alma:review-mr <MR 編號>`：review 一張 GitLab MR，從需求推、先討論設計再看 bug
- `alma:principles`：上面兩個共用的工程原則。兩個指令開始時都會先載入它，review-mr 只放 review 專屬的部分
- `rules/communication.md`：溝通規則，每個 session 開始時由 hook 自動載入（新 session、`/clear`、壓縮後都會）
- `backup/`：大改前的舊版，plugin 不會載入

## 設定

### GitLab（review-mr 用）

```bash
export GITLAB_URL=https://gitlab.example.com
export GITLAB_PROJECT_ID=123
```

發 comment 的 token 從 `git credential fill` 取，取不到再讀 `GITLAB_TOKEN`。環境變數沒設時，它會去查 Claude Code 替這個專案記的 auto-memory（`MEMORY.md`），再沒有就直接問你。

### 溝通規則

裝好就生效，不用另外設定。不想要的話，刪掉或改寫 `rules/communication.md`；只想關掉 hook，可以在 `/plugin` 裡停用整個 plugin。

## 適用範圍

- 全部用繁體中文。
- `review-mr` 綁 GitLab；讀需求那步預設有 Jira，沒有也能跑，只是目標會標成推測。
