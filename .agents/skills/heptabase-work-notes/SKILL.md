---
name: heptabase-work-notes
description: 使用 Heptabase CLI 查詢、建立或更新「工作思考」專案在 Heptabase 的「個人知識管理」白板和筆記，並將卡片放入對應的子白板。
---

# 個人知識管理

搭配同目錄下的官方 [heptabase-cli 技能](../heptabase-cli/SKILL.md)。依官方技能確認 CLI 版本並讀取內建手冊。操作工作空間前依手冊讀取 Space Instructions。若無法連線，用 `heptabase start` 檢查桌面版是否就緒。

## 找到指定內容

1. 用 `heptabase whiteboard list --name-filter '個人知識管理'` 找到主白板，再用 `heptabase whiteboard read '<白板 ID>' --mode structure` 確認其子白板。若同名白板無法區分，請使用者指定。
2. 搜尋某個子白板時，用 `heptabase search keyword '<關鍵字>' --whiteboard-id '<子白板 ID>'` 縮小範圍。需要摘要筆記時，用 `heptabase object read card '<卡片 ID>'` 讀取選定卡片。
3. 使用者指定的目的地優先。需要依專案現有架構放置新卡片時，依內容選擇：

   | 子白板 | 用途 |
   | --- | --- |
   | 待整理 | 臨時想法、待消化的資料 |
   | 主題筆記 | 工作方法或長期累積的知識，例如「個資管理」 |
   | 決策紀錄 | 決定、理由和回顧問題 |
   | 可重用工具 | 範本、檢查清單與操作指引 |

## 儲存與驗證

- 新筆記用 `heptabase note create --content-file '<檔案>'` 建立，Markdown 第一行用 `# 標題`。再用 `heptabase whiteboard add-card --whiteboard-id '<子白板 ID>' --card-id '<回傳的卡片 ID>'` 放置。若新增成功但放置失敗，使用已回傳的卡片 ID 恢復放置。
- 更新既有卡片時，先讀取原文，再依內建 `hepta-markdown` 手冊使用 `note edit` 更新使用者指定的部分。
- 個資主題筆記使用資料類別、處理流程或去識別化範例。完成後核對卡片名稱與所在白板，簡短回報結果。
