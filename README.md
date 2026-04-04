# claude-statusline

Claude Code 狀態列腳本，顯示專案路徑、Git 狀態、Context 用量、5小時及7天用量與重置時間。

## 顯示格式

```
D:\Projects\myapp | git:main* | ctx:14% | 5h:18%→03:00 | 7d:5%→2026-04-10 21:00
```

| 項目 | 顏色 |
|------|------|
| 專案路徑 | 青色 |
| git 分支（乾淨） | 黃色 |
| git 分支（有未提交變更，加 `*`） | 紅色粗體 |
| 用量 < 50% | 綠色 |
| 用量 50–79% | 黃色 |
| 用量 >= 80% | 紅色 |

## 需求

- **jq** 或 **Python 3**（擇一即可）
- Git

---

## 安裝

### Windows（Git Bash）

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

### Windows（Git Bash）

```bash
~/.claude/statusline/update.sh
```

### WSL

```bash
~/.claude/statusline/update.sh
```

更新後重新啟動 Claude Code。

---

## 手動設定（選用）

若 `setup-settings.py` 無法執行，請手動編輯 `~/.claude/settings.json`，加入以下內容：

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash /home/你的帳號/.claude/statusline/statusline.sh"
  }
}
```

Windows 路徑範例：

```json
"command": "bash C:/Users/你的帳號/.claude/statusline/statusline.sh"
```
