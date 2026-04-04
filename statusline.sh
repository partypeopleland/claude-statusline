#!/usr/bin/env bash
# Claude Code status line script

input=$(cat)
echo "$input" > /tmp/statusline-debug.json
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse JSON via Python helper script
parsed=$(echo "$input" | python "$SCRIPT_DIR/statusline-parse.py" 2>/dev/null)
project_dir=$(echo "$parsed" | sed -n '1p')
ctx_pct=$(echo "$parsed"     | sed -n '2p')
five_pct=$(echo "$parsed"    | sed -n '3p')
five_reset=$(echo "$parsed"  | sed -n '4p')
week_pct=$(echo "$parsed"    | sed -n '5p')
week_reset=$(echo "$parsed"  | sed -n '6p')

# Convert Windows backslash path to forward slash for git
git_dir=$(echo "$project_dir" | sed 's|\\|/|g' | sed 's|^\([A-Za-z]\):|/\L\1|')

# --- Colors (256-color ANSI — soft, non-glaring palette) ---
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
COLOR_PATH="\033[38;5;117m"        # soft sky blue
COLOR_GIT="\033[38;5;153m"         # bright sky blue
COLOR_GIT_DIRTY="\033[38;5;215m"   # soft orange (replaces harsh red)
COLOR_RESET_TIME="\033[38;5;152m"  # soft cyan for reset times

# Usage color: soft green / amber / muted coral based on integer part
usage_color() {
    local i="${1%%.*}"
    if   [ "$i" -ge 80 ]; then printf "\033[38;5;167m"  # muted coral
    elif [ "$i" -ge 50 ]; then printf "\033[38;5;179m"  # soft amber
    else                       printf "\033[38;5;114m"  # soft green
    fi
}

# --- 1. Project path ---
path_part=""
if [ -n "$project_dir" ]; then
    path_part=$(printf "${COLOR_PATH}${BOLD}❯ %s${RESET}" "$project_dir")
fi

# --- 2. Git status ---
git_part=""
if [ -n "$git_dir" ] && [ -d "$git_dir/.git" ]; then
    branch=$(git -C "$git_dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        dirty=$(git -C "$git_dir" --no-optional-locks status --porcelain 2>/dev/null)
        if [ -n "$dirty" ]; then
            git_part=$(printf "${COLOR_GIT_DIRTY}${BOLD}⎇ %s ✦${RESET}" "$branch")
        else
            git_part=$(printf "${COLOR_GIT}⎇ %s${RESET}" "$branch")
        fi
    fi
fi

# --- 3. Context window ---
ctx_part=""
if [ -n "$ctx_pct" ]; then
    col=$(usage_color "$ctx_pct")
    ctx_part=$(printf "${col}◷ %s%%${RESET}" "$ctx_pct")
fi

# --- 4. 5-hour usage + reset time ---
five_part=""
if [ -n "$five_pct" ]; then
    col=$(usage_color "$five_pct")
    five_part=$(printf "${col}» 5h %s%%${RESET}" "$five_pct")
    if [ -n "$five_reset" ]; then
        five_part=$(printf "%s${COLOR_RESET_TIME} → %s${RESET}" "$five_part" "$five_reset")
    fi
fi

# --- 5. 7-day usage + reset time ---
week_part=""
if [ -n "$week_pct" ]; then
    col=$(usage_color "$week_pct")
    week_part=$(printf "${col}≫ 7d %s%%${RESET}" "$week_pct")
    if [ -n "$week_reset" ]; then
        week_part=$(printf "%s${COLOR_RESET_TIME} → %s${RESET}" "$week_part" "$week_reset")
    fi
fi

# --- Assemble with soft separator ---
parts=()
[ -n "$path_part" ] && parts+=("$path_part")
[ -n "$git_part"  ] && parts+=("$git_part")
[ -n "$ctx_part"  ] && parts+=("$ctx_part")
[ -n "$five_part" ] && parts+=("$five_part")
[ -n "$week_part" ] && parts+=("$week_part")

sep=$(printf "${DIM} · ${RESET}")
output=""
for i in "${!parts[@]}"; do
    [ "$i" -eq 0 ] && output="${parts[$i]}" || output="${output}${sep}${parts[$i]}"
done

printf "%b\n" "$output"
