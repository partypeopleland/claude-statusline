#!/usr/bin/env bash
# Update claude-statusline
# Usage: ~/.claude/statusline/update.sh

set -e
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[claude-statusline] Updating..."
git -C "$INSTALL_DIR" pull --ff-only
echo "[claude-statusline] Done! Restart Claude Code to apply."
