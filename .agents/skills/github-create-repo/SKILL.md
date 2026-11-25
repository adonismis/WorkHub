---
name: github-create-repo
description: 使用 GitHub CLI（gh）在 GitHub 建立新的儲存庫，並可上傳使用者指定的本機檔案。適用於建立 GitHub 儲存庫或將新專案發布到 GitHub。
---

# 建立 GitHub 儲存庫

1. 從對話確認儲存庫名稱、擁有者及要放入的檔案。擁有者預設為目前登入的個人帳號，可見性預設為私人。使用 `gh api user --jq .login` 核對登入帳號與預期的擁有者。
2. 若尚未安裝 `gh`，依環境使用官方安裝方式，例如已裝 Homebrew 的 Mac 可用 `brew install gh`。若尚未登入，啟動 `gh auth login --hostname github.com --git-protocol https --web`，請使用者在 GitHub 完成授權。只需使用 GitHub API 時，可以略過 Git 憑證設定。
3. 用 `gh repo create OWNER/NAME --private` 建立儲存庫。如果使用者指定其他可見性，就改用對應旗標。若要另行加入少量檔案，可加上 `--add-readme` 初始化預設分支，再透過 GitHub Contents API 寫入指定路徑。若要推送指定的本機 Git 專案，先檢查要推送的提交和遠端設定，再視情況用 `--source` 與 `--push`。只發布使用者授權的內容。
4. 如果名稱已存在，或建立時出現網路錯誤，先用 `gh repo view OWNER/NAME --json url,visibility` 確認遠端狀態。只有確定是這次成功建立的儲存庫才繼續上傳。若建立成功但上傳失敗，保留已建立的儲存庫，確認檔案狀態後再重試上傳。
5. 回報前核對 GitHub 上的儲存庫 URL、可見性及指定檔案是否存在。提供儲存庫連結，並說明尚未完成的部分。
