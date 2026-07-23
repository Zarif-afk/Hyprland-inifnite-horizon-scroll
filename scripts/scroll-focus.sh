#!/usr/bin/env bash
set -euo pipefail

direction="${1:?direction required}"

before="$(hyprctl activewindow -j 2>/dev/null || true)"
before_addr=""
before_col=""
before_row=""

if [[ -n "$before" ]]; then
  before_addr="$(jq -r '.address // empty' <<<"$before")"
  before_col="$(jq -r '.layout.pos_in_scrolling_layout[0] // empty' <<<"$before")"
  before_row="$(jq -r '.layout.pos_in_scrolling_layout[1] // empty' <<<"$before")"
fi

hyprctl dispatch layoutmsg "focus $direction" >/dev/null 2>&1 || true

after="$(hyprctl activewindow -j 2>/dev/null || true)"
after_addr=""
after_col=""
after_row=""

if [[ -n "$after" ]]; then
  after_addr="$(jq -r '.address // empty' <<<"$after")"
  after_col="$(jq -r '.layout.pos_in_scrolling_layout[0] // empty' <<<"$after")"
  after_row="$(jq -r '.layout.pos_in_scrolling_layout[1] // empty' <<<"$after")"
fi

if [[ -z "$before_addr" || ( "$before_addr" == "$after_addr" && "$before_col" == "$after_col" && "$before_row" == "$after_row" ) ]]; then
  hyprctl dispatch movefocus "$direction"
fi
