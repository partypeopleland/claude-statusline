# claude-statusline

Claude Code 狀態列腳本，顯示專案路徑、Git 狀態、Context 用量、5小時及7天用量與重置時間。

## 顯示格式

```
❯ D:\Projects\myapp · ⎇ main · ◷ 14.0% · » 5h 18.0% → 03:00 · ≫ 7d 5.0% → 04-10 21:00 FRI
```

| 項目 | 說明 | 顏色 |
|------|------|------|
| `❯ 專案路徑` | 完整專案路徑 | 天空藍 |
| `⎇ 分支`（乾淨） | Git 分支名稱 | 亮藍色 |
| `⎇ 分支 ✦`（有未提交變更） | 加 `✦` 標示 dirty | 柔橙色粗體 |
| `◷` Context 用量 | 目前對話 context 使用率 | 依用量顯示 |
| `» 5h` 用量 | 5 小時內用量，`→ HH:MM` 為重置時間 | 依用量顯示 |
| `≫ 7d` 用量 | 7 天用量，`→ MM-DD HH:MM DAY` 為重置時間 | 依用量顯示 |

**用量顏色：**

| 用量 | 顏色 |
|------|------|
| < 50% | 柔綠色 |
| 50–79% | 琥珀色 |
| ≥ 80% | 珊瑚紅 |

> 百分比顯示採無條件進位至小數點第1位（例：14.1% → 14.2%）。

## 需求

- **Python 3**
- Git

---

## 安裝

### Windows（Git Bash）

> 請在 **Git Bash** 執行，不要在 WSL 或 PowerShell 執行。

```bash
git clone https://github.com/partypeopleland/claude-statusline.git ~/.claude/statusline
python ~/.claude/statusline/setup-settings.py ~/.claude/statusline ~/.claude/settings.json
```

重新啟動 Claude Code 即生效。

### WSL（Ubuntu / Debian）

```bash
git clone git@github.com:partypeopleland/claude-statusline.git ~/.claude/statusline
python3 ~/.claude/statusline/setup-settings.py ~/.claude/statusline ~/.claude/settings.json
```

重新啟動 Claude Code 即生效。

---

## 更新

```bash
~/.claude/statusline/update.sh
```

更新後重新啟動 Claude Code。

---

## 手動設定（選用）

若 `setup-settings.py` 無法執行，請手動編輯 `~/.claude/settings.json`，加入以下內容：

**WSL：**
```json
{
  "statusLine": {
    "type": "command",
    "command": "bash /home/你的帳號/.claude/statusline/statusline.sh"
  }
}
```

**Windows（Git Bash）：**
```json
{
  "statusLine": {
    "type": "command",
    "command": "bash C:/Users/你的帳號/.claude/statusline/statusline.sh"
  }
}
```

---

## 疑難排解

### 安裝後狀態列沒有出現

**1. 確認是在 Git Bash 安裝（Windows 用戶）**

`~` 在 Git Bash 對應 `C:/Users/你的帳號/`，在 WSL 對應 `/home/你的帳號/`。
兩者是不同路徑。Windows 版 Claude Code 需要安裝在 Git Bash 的 `~` 下。

**2. 檢查專案層級設定是否覆蓋全域設定**

Claude Code 的專案層級 `.claude/settings.json` 會覆蓋全域 `~/.claude/settings.json`。
若目前開啟的專案下有 `.claude/settings.json` 且包含 `statusLine`，全域設定會被忽略。

解法：開啟專案的 `.claude/settings.json`，移除其中的 `statusLine` 區塊，或確認它指向正確路徑。

**3. 確認 clone 成功**

```bash
ls ~/.claude/statusline/
```

應看到 `statusline.sh`、`statusline-parse.py` 等檔案。若目錄不存在，表示 clone 失敗。
Private repo 使用 HTTPS clone 需要 GitHub 認證（Windows Credential Manager 或 Personal Access Token）。

**4. 手動測試腳本**

```bash
echo '{}' | bash ~/.claude/statusline/statusline.sh
```

有輸出代表腳本正常，問題在 settings.json 設定。無輸出代表腳本本身有問題。
