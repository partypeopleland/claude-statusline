  # claude-statusline

  Claude Code 狀態列腳本，顯示專案路徑、Git 狀態、Context 用量、5小時及7天用量與重置時間。

  ## 顯示格式

  ❯ D:\Projects\myapp · ⎇ main · ◷ 14.0% · » 5h 18.0% → 03:00 · ≫ 7d 5.0% → 04-10 21:00 FRI

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

```bash
  git clone https://github.com/partypeopleland/claude-statusline.git ~/.claude/statusline
  python ~/.claude/statusline/setup-settings.py ~/.claude/statusline ~/.claude/settings.json
```
  重新啟動 Claude Code 即生效。

  WSL（Ubuntu / Debian）

```bash
  git clone git@github.com:partypeopleland/claude-statusline.git ~/.claude/statusline
  python3 ~/.claude/statusline/setup-settings.py ~/.claude/statusline ~/.claude/settings.json
```
  重新啟動 Claude Code 即生效。

  ---
  更新

  Windows（Git Bash）
```bash
  ~/.claude/statusline/update.sh
```
  WSL
```bash
  ~/.claude/statusline/update.sh
```
  更新後重新啟動 Claude Code。

  ---
  手動設定（選用）

  若 setup-settings.py 無法執行，請手動編輯 ~/.claude/settings.json，加入以下內容：
```json
  {
    "statusLine": {
      "type": "command",
      "command": "bash /home/你的帳號/.claude/statusline/statusline.sh"
    }
  }
```
  Windows 路徑範例：
```
  "command": "bash C:/Users/你的帳號/.claude/statusline/statusline.sh"
```
  ---

  更新內容：顯示格式範例、icon 說明、顏色欄位、無條件進位說明、移除 jq 需求（只剩 Python 3）。
