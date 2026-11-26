[https://github.com/adonismis/WorkHub](https://github.com/adonismis/WorkHub)

# 工作思考

## 專案 Submodule

| 資料夾 | GitHub 儲存庫 |
| --- | --- |
| `ilwct_server` | [adonismis/ilwct_server](https://github.com/adonismis/ilwct_server) |
| `savs` | [adonismis/savs](https://github.com/adonismis/savs) |
| `ruiyang-em.com` | [adonismis/ruiyang-em.com](https://github.com/adonismis/ruiyang-em.com) |
| `ilwct_life` | [adonismis/ilwct_life](https://github.com/adonismis/ilwct_life) |

複製本儲存庫後，可初始化並下載所有 submodule：

```sh
git submodule update --init --recursive
```

### 自動提出更新 PR

推送提交到任一子專案的 `main` 後，子專案會通知 WorkHub。WorkHub 檢查四個子專案的 `main`，有新版本時建立或更新一張 PR。合併 PR 後，WorkHub 才會記錄新的 submodule 版本。也可以在 WorkHub 的 Actions 介面手動執行 **Update submodules**。

啟用時，請建立兩個 [fine-grained personal access token](https://github.com/settings/personal-access-tokens/new)，並在各儲存庫的 **Settings → Secrets and variables → Actions** 中設定：

| Secret | 設定位置 | 權限 |
| --- | --- | --- |
| `WORKHUB_DISPATCH_TOKEN` | 四個子專案 | 僅選 WorkHub，設定 Contents 為 Read and write |
| `WORKHUB_SUBMODULE_READ_TOKEN` | WorkHub | 僅選四個子專案，設定 Contents 為 Read-only |

WorkHub 的 **Settings → Actions → General** 也需開啟 **Allow GitHub Actions to create and approve pull requests**，讓 workflow 可以建立 PR。設定好 Secret 後，可手動執行一次 **Update submodules** 以確認連線與權限。

## 專案技能清單

在 Codex 開啟「工作思考」後，可以直接輸入表中的提示詞。

| 技能 | 用途 | 使用範例 |
| --- | --- | --- |
| [`$github-create-repo`](.agents/skills/github-create-repo/SKILL.md) | 用 GitHub CLI 建立儲存庫，預設為私人，可上傳指定檔案。 | 用 `$github-create-repo` 建立新的私人儲存庫 `project-notes`。 |
| [`$heptabase-cli`](.agents/skills/heptabase-cli/SKILL.md) | Heptabase 官方技能，可搜尋卡片、編輯筆記和管理白板。 | 用 `$heptabase-cli` 列出最近編輯的五張白板。 |
| [`$heptabase-work-notes`](.agents/skills/heptabase-work-notes/SKILL.md) | 依「個人知識管理」的專案分類查找、建立和放置卡片。 | 用 `$heptabase-work-notes` 在「主題筆記」找「個資管理」，摘要三個重點。 |

## Heptabase CLI 使用說明

這個專案用 Heptabase 的「個人知識管理」白板整理知識。下面有四個子白板：待整理、主題筆記、決策紀錄、可重用工具。

### 在 Codex 使用

開啟「工作思考」專案，輸入以下任一指令式提示詞。

- 用 `$heptabase-work-notes` 列出「個人知識管理」下的子白板。
- 用 `$heptabase-work-notes` 在「主題筆記」找「個資管理」，摘要三個重點。
- 用 `$heptabase-work-notes` 把下面的 Markdown 建成卡片，放到「決策紀錄」。

專案技能會確認白板和卡片的位置，再依照你的要求查詢或更新。

### 在終端機使用

在 Heptabase 桌面版的 **設定 → AI Features → CLI** 開啟功能。用以下指令檢查 CLI 版本和連線。

```sh
heptabase --version
heptabase start
```

看到 `"status": "ready"` 就可以使用。以下是常用指令，尖括號內請換成查詢結果回傳的 ID。

```sh
heptabase whiteboard list --name-filter '個人知識管理'
heptabase whiteboard read '<白板 ID>' --mode structure
heptabase search keyword '個資管理' --whiteboard-id '<白板 ID>'
heptabase object read card '<卡片 ID>'
```

要新增筆記時，先準備好 Markdown 檔，第一行用 `# 標題`。建立後，用回傳的卡片 ID 放入指定白板。

```sh
heptabase note create --content-file './筆記.md'
heptabase whiteboard add-card --whiteboard-id '<白板 ID>' --card-id '<新卡片 ID>'
```

[Heptabase CLI 官方說明](https://support.heptabase.com/en/articles/14715462-heptabase-cli)
