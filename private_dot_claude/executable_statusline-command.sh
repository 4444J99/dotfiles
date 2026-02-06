#!/usr/bin/env bash

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract current directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Format directory - replace home with ~
dir="$cwd"
if [[ "$dir" == "$HOME"* ]]; then
  dir="~${dir#$HOME}"
fi

# Truncate directory to last 4 components (like Starship)
IFS='/' read -ra parts <<<"$dir"
if [[ ${#parts[@]} -gt 4 ]]; then
  dir=".../${parts[-3]}/${parts[-2]}/${parts[-1]}"
fi

# Git branch and status (if in git repo)
git_info=""
if git -C "$cwd" rev-parse --git-dir &>/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c "gc.auto=0" branch --show-current 2>/dev/null || git -C "$cwd" -c "gc.auto=0" rev-parse --short HEAD 2>/dev/null)
  if [[ -n "$branch" ]]; then
    git_info=" on $branch"

    # Git status
    status=$(git -C "$cwd" -c "gc.auto=0" status --porcelain 2>/dev/null)
    if [[ -n "$status" ]]; then
      untracked=$(echo "$status" | grep -c "^??" || true)
      modified=$(echo "$status" | grep -c "^ M" || true)
      staged=$(echo "$status" | grep -c "^M" || true)
      deleted=$(echo "$status" | grep -c "^ D" || true)

      git_status=""
      [[ $staged -gt 0 ]] && git_status="${git_status}+${staged}"
      [[ $modified -gt 0 ]] && git_status="${git_status}!${modified}"
      [[ $deleted -gt 0 ]] && git_status="${git_status}x${deleted}"
      [[ $untracked -gt 0 ]] && git_status="${git_status}?${untracked}"

      [[ -n "$git_status" ]] && git_info="${git_info} [${git_status}]"
    fi
  fi
fi

# Model info
model=$(echo "$input" | jq -r '.model.display_name')

# Time
time=$(date +%H:%M)

# Output format: directory + git + model + time
printf "%s%s | %s %s" "$dir" "$git_info" "$model" "$time"
