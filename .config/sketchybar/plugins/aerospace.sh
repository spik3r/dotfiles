#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(dirname "$(dirname "$0")")}"
source "$CONFIG_DIR/current-theme"

WORKSPACE="$1"
FOCUSED_WORKSPACE="${FOCUSED_WORKSPACE:-}"
VISIBLE_WORKSPACES=""

if [ -z "$FOCUSED_WORKSPACE" ] && command -v aerospace >/dev/null 2>&1; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

if command -v aerospace >/dev/null 2>&1; then
  VISIBLE_WORKSPACES="$(aerospace list-workspaces --monitor all --visible 2>/dev/null)"
fi

HAS_WINDOWS=false
if command -v aerospace >/dev/null 2>&1; then
  WINDOW_COUNT=$(aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | wc -l | tr -d ' ')
  if [ "${WINDOW_COUNT:-0}" -gt 0 ]; then
    HAS_WINDOWS=true
  fi
fi

if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" \
    label.color="$TEXT_HIGHLIGHT_COLOR" \
    label.font="$LABEL_HIGHLIGHT_FONT" \
    background.drawing=on \
    background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
    background.border_color="$TEXT_HIGHLIGHT_COLOR" \
    background.border_width=1
elif printf '%s\n' "$VISIBLE_WORKSPACES" | grep -qx "$WORKSPACE"; then
  sketchybar --set "$NAME" \
    label.color="$TEXT_COLOR" \
    label.font="$LABEL_HIGHLIGHT_FONT" \
    background.drawing=on \
    background.color=0x331c3052 \
    background.border_color="$SECTION_BORDER_COLOR" \
    background.border_width=1
elif [ "$HAS_WINDOWS" = true ]; then
  sketchybar --set "$NAME" \
    label.color="$TEXT_COLOR" \
    label.font="$LABEL_FONT" \
    background.drawing=on \
    background.color=0x223d5a7a \
    background.border_width=0
else
  sketchybar --set "$NAME" \
    label.color=0x99f0f0f0 \
    label.font="$LABEL_FONT" \
    background.drawing=on \
    background.color=0x00000000 \
    background.border_width=0
fi
