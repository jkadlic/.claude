#!/bin/bash
# Prints the status line from the session JSON that Claude Code sends on stdin.
# Output looks like: Opus 5.5 · kothon (main*) · context 62% · +120 −34 · 1h 12m · $1.40 · 14:32

input=$(cat)

YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

model=$(jq -r '.model.display_name // "Claude"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // empty' <<<"$input")
added=$(jq -r '.cost.total_lines_added // empty' <<<"$input")
removed=$(jq -r '.cost.total_lines_removed // empty' <<<"$input")
duration_ms=$(jq -r '.cost.total_duration_ms // empty | floor' <<<"$input" 2>/dev/null)

# Older versions don't send used_percentage, so it is computed from the token counts when missing.
context=$(jq -r '
  .context_window as $w
  | if $w == null then empty
    elif $w.used_percentage != null then $w.used_percentage
    elif ($w.current_usage != null and ($w.context_window_size // 0) > 0) then
      (($w.current_usage.input_tokens // 0)
       + ($w.current_usage.cache_creation_input_tokens // 0)
       + ($w.current_usage.cache_read_input_tokens // 0)) * 100 / $w.context_window_size
    else empty end
  | floor' <<<"$input" 2>/dev/null)

parts=("$model")

if [ -n "$dir" ]; then
  folder=$(basename "$dir")
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    # Untracked files are skipped (-uno) because scanning for them is slow in large repos.
    if [ -n "$(git -C "$dir" --no-optional-locks status --porcelain -uno 2>/dev/null)" ]; then
      branch="$branch*"
    fi
    parts+=("$folder ($branch)")
  else
    parts+=("$folder")
  fi
fi

if [ -n "$context" ]; then
  if [ "$context" -ge 80 ]; then
    parts+=("${RED}context ${context}%${RESET}")
  elif [ "$context" -ge 60 ]; then
    parts+=("${YELLOW}context ${context}%${RESET}")
  else
    parts+=("context ${context}%")
  fi
fi

if [ -n "$added" ] || [ -n "$removed" ]; then
  parts+=("+${added:-0} −${removed:-0}")
fi

if [ -n "$duration_ms" ]; then
  minutes=$((duration_ms / 60000))
  if [ "$minutes" -ge 60 ]; then
    parts+=("$((minutes / 60))h $(printf '%02d' $((minutes % 60)))m")
  else
    parts+=("${minutes}m")
  fi
fi

[ -n "$cost" ] && parts+=("$(printf '$%.2f' "$cost")")

parts+=("$(date +%H:%M)")

line=""
for part in "${parts[@]}"; do
  line="${line:+$line · }$part"
done
printf '%s' "$line"
