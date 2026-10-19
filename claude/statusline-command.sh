#!/bin/bash
# Claude Code statusLine — recreates the oh-my-zsh agnoster segmented/powerline
# look, with Claude Code model + context + rate-limit info appended as segments.
#
# Segments (left to right):
#   1. cwd (basename)              - blue bg
#   2. git branch + dirty marker   - green (clean) / yellow (dirty) bg
#   3. model display name          - dark grey bg
#   4. context usage percentage    - darker grey bg
#   5. day rate-limit (5-hour)      - green/yellow/red by threshold
#   6. week rate-limit (7-day)      - green/yellow/red by threshold
#
# Requires a Nerd/Powerline-patched font for the  arrow glyph to render.

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd="$PWD"
dir=$(basename "$cwd")

model=$(echo "$input" | jq -r '.model.display_name // empty')
[ -z "$model" ] && model="claude"

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ] && [ "$used" != "null" ]; then
  ctx=$(printf '%.0f' "$used")
else
  ctx="--"
fi

# rate-limit usage percentages (5-hour and 7-day/weekly windows)
rl_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

git_branch=""
git_dirty=0
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
    git_dirty=1
  fi
fi

# agnoster-ish 256-color palette
DIR_BG=25;   DIR_FG=255    # blue
GIT_CLEAN_BG=64; GIT_DIRTY_BG=136; GIT_FG=0   # green / yellow, black text
MODEL_BG=239; MODEL_FG=255 # dark grey
CTX_BG=235;  CTX_FG=250    # darker grey

# rate-limit threshold colors (background): green < 50 <= yellow < 80 <= red
RL_OK_BG=22; RL_WARN_BG=136; RL_HOT_BG=88
rl_bg() {
  local pct="$1"
  if [ "$pct" -ge 80 ]; then echo "$RL_HOT_BG"
  elif [ "$pct" -ge 50 ]; then echo "$RL_WARN_BG"
  else echo "$RL_OK_BG"; fi
}

ARROW=''

bgs=()
fgs=()
texts=()

bgs+=("$DIR_BG"); fgs+=("$DIR_FG"); texts+=("  $dir ")

if [ -n "$git_branch" ]; then
  if [ "$git_dirty" = "1" ]; then
    git_bg=$GIT_DIRTY_BG
    marker=" ✚"
  else
    git_bg=$GIT_CLEAN_BG
    marker=""
  fi
  bgs+=("$git_bg"); fgs+=("$GIT_FG"); texts+=("  $git_branch$marker ")
fi

bgs+=("$MODEL_BG"); fgs+=("$MODEL_FG"); texts+=("  $model ")
bgs+=("$CTX_BG"); fgs+=("$CTX_FG"); texts+=(" ctx ${ctx}% ")

if [ -n "$rl_5h" ] && [ "$rl_5h" != "null" ]; then
  pct=$(printf '%.0f' "$rl_5h")
  bgs+=("$(rl_bg "$pct")"); fgs+=("255"); texts+=(" day ${pct}% ")
fi
if [ -n "$rl_7d" ] && [ "$rl_7d" != "null" ]; then
  pct=$(printf '%.0f' "$rl_7d")
  bgs+=("$(rl_bg "$pct")"); fgs+=("255"); texts+=(" week ${pct}% ")
fi

prev_bg=""
for i in "${!bgs[@]}"; do
  bg="${bgs[$i]}"
  fg="${fgs[$i]}"
  text="${texts[$i]}"
  if [ -n "$prev_bg" ]; then
    printf "\033[38;5;%sm\033[48;5;%sm${ARROW}" "$prev_bg" "$bg"
  fi
  printf "\033[48;5;%sm\033[38;5;%sm%s" "$bg" "$fg" "$text"
  prev_bg="$bg"
done

printf "\033[38;5;%sm\033[49m${ARROW}\033[0m\n" "$prev_bg"
