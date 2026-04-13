#!/usr/bin/env bash
input=$(cat)
user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git branch (skip optional locks)
branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.fsmonitor=false symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.fsmonitor=false rev-parse --short HEAD 2>/dev/null)
fi

# Line 1: user@host /current/dir (git-branch)
line1="${user}@${host} ${cwd}"
[ -n "$branch" ] && line1="${line1} (${branch})"

# Line 2: Model Name [████████░░░░░░░░] 42%
line2=""
if [ -n "$model" ] || [ -n "$used" ]; then
  bar=""
  pct_label=""
  if [ -n "$used" ]; then
    printf -v pct "%.0f" "$used"
    filled=$(( pct * 16 / 100 ))
    empty=$(( 16 - filled ))
    bar="["
    for i in $(seq 1 $filled); do bar="${bar}█"; done
    for i in $(seq 1 $empty);  do bar="${bar}░"; done
    bar="${bar}]"
    pct_label="${pct}%"
  fi
  line2="${model}"
  [ -n "$bar" ]       && line2="${line2} ${bar}"
  [ -n "$pct_label" ] && line2="${line2} ${pct_label}"
fi

if [ -n "$line2" ]; then
  printf "%s\n%s" "$line1" "$line2"
else
  printf "%s" "$line1"
fi
