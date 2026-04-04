#!/usr/bin/env bash
# Install claude-statusline
# Usage: curl -sSL https://raw.githubusercontent.com/partypeopleland/claude-statusline/main/install.sh | bash

set -e

REPO="https://github.com/partypeopleland/claude-statusline.git"
INSTALL_DIR="$HOME/.claude/statusline"
SETTINGS="$HOME/.claude/settings.json"

echo "[claude-statusline] Installing..."

if [ -d "$INSTALL_DIR/.git" ]; then
    echo "[claude-statusline] Found existing install, updating..."
    git -C "$INSTALL_DIR" pull --ff-only
else
    echo "[claude-statusline] Cloning to $INSTALL_DIR ..."
    git clone "$REPO" "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/statusline.sh" "$INSTALL_DIR/update.sh"

PY=$(command -v python3 2>/dev/null || command -v python 2>/dev/null || echo "")

if [ -z "$PY" ] && ! command -v jq &>/dev/null; then
    echo "[claude-statusline] ERROR: Need python3, python, or jq."
    exit 1
fi

if [ -n "$PY" ]; then
    "$PY" "$INSTALL_DIR/setup-settings.py" "$INSTALL_DIR" "$SETTINGS"
else
    echo "[claude-statusline] Add manually to $SETTINGS:"
    echo "  \"statusLine\": { \"type\": \"command\", \"command\": \"bash $INSTALL_DIR/statusline.sh\" }"
fi

echo "[claude-statusline] Done! Restart Claude Code to activate."
