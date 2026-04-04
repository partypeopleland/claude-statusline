#!/usr/bin/env bash
# Claude Code status line
# https://github.com/partypeopleland/claude-statusline

input=$(cat)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- JSON parsing (jq → python3 → python) ---
if command -v jq &>/dev/null; then
    project_dir=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir // .cwd // ""')
    ctx_pct=$(echo "$input"     | jq -r '.context_window.used_percentage // ""')
    five_pct=$(echo "$input"    | jq -r '.rate_limits.five_hour.used_percentage // ""')
    five_ts=$(echo "$input"     | jq -r '.rate_limits.five_hour.resets_at // ""')
    week_pct=$(echo "$input"    | jq -r '.rate_limits.seven_day.used_percentage // ""')
    week_ts=$(echo "$input"     | jq -r '.rate_limits.seven_day.resets_at // ""')
    _fmt_date() {
        date -d "@$1" "$2" 2>/dev/null || date -r "$1" "$2" 2>/dev/null || echo ""
    }
    [ -n "$five_ts" ] && five_reset=$(_fmt_date "$five_ts" '+%H:%M')           || five_reset=""
    [ -n "$week_ts" ] && week_reset=$(_fmt_date "$week_ts" '+%Y-%m-%d %H:%M')  || week_reset=""
else
    PY=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
    if [ -z "$PY" ]; then
        echo "claude-statusline: need jq or python" >&2
        exit 1
    fi
    parsed=$(echo "$input" | "$PY" "$SCRIPT_DIR/statusline-parse.py" 2>/dev/null)
    project_dir=$(echo "$parsed" | sed -n '1p')
    ctx_pct=$(echo "$parsed"     | sed -n '2p')
    five_pct=$(echo "$parsed"    | sed -n '3p')
    five_reset=$(echo "$parsed"  | sed -n '4p')
    week_pct=$(echo "$parsed"    | sed -n '5p')
    week_reset=$(echo "$parsed"  | sed -n '6p')
fi

# Convert Windows backslash path to Unix for git
git_dir=$(echo "$project_dir" | sed 's|\|/|g' | sed 's|^\([A-Za-z]\):|/\L\1|')

# --- Colors ---
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
C_PATH="\033[36m"
C_GIT="\033[33m"
C_GIT_DIRTY="\033[31m"

usage_color() {
    local n="$1"
    if   [ "$n" -ge 80 ] 2>/dev/null; then printf "\033[31m"
    elif [ "$n" -ge 50 ] 2>/dev/null; then printf "\033[33m"
    else                                    printf "\033[32m"
    fi
}

# --- 1. Project path ---
path_part=""
if [ -n "$project_dir" ]; then
    path_part=$(printf "${C_PATH}${BOLD}%s${RESET}" "$project_dir")
fi

# --- 2. Git status ---
git_part=""
if [ -n "$git_dir" ] && [ -d "$git_dir/.git" ]; then
    branch=$(git -C "$git_dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        dirty=$(git -C "$git_dir" --no-optional-locks status --porcelain 2>/dev/null)
        if [ -n "$dirty" ]; then
            git_part=$(printf "${C_GIT_DIRTY}${BOLD}git:${branch}*${RESET}")
        else
            git_part=$(printf "${C_GIT}git:${branch}${RESET}")
        fi
    fi
fi

# --- 3. Context window ---
ctx_part=""
if [ -n "$ctx_pct" ]; then
    col=$(usage_color "$ctx_pct")
    ctx_part=$(printf "${col}ctx:${ctx_pct}%%${RESET}")
fi

# --- 4. 5-hour usage ---
five_part=""
if [ -n "$five_pct" ]; then
    col=$(usage_color "$five_pct")
    five_part=$(printf "${col}5h:${five_pct}%%${RESET}")
    [ -n "$five_reset" ] && five_part="${five_part}$(printf "${DIM}→${five_reset}${RESET}")"
fi

# --- 5. 7-day usage ---
week_part=""
if [ -n "$week_pct" ]; then
    col=$(usage_color "$week_pct")
    week_part=$(printf "${col}7d:${week_pct}%%${RESET}")
    [ -n "$week_reset" ] && week_part="${week_part}$(printf "${DIM}→${week_reset}${RESET}")"
fi

# --- Assemble ---
parts=()
[ -n "$path_part" ] && parts+=("$path_part")
[ -n "$git_part"  ] && parts+=("$git_part")
[ -n "$ctx_part"  ] && parts+=("$ctx_part")
[ -n "$five_part" ] && parts+=("$five_part")
[ -n "$week_part" ] && parts+=("$week_part")

sep=$(printf "${DIM} | ${RESET}")
output=""
for idx in "${!parts[@]}"; do
    [ "$idx" -eq 0 ] && output="${parts[$idx]}" || output="${output}${sep}${parts[$idx]}"
done

printf "%b\n" "$output"
