#!/usr/bin/env bash

source "$HOME/.config/sketchybar/current-theme"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e "output volume of (get volume settings)")
fi

# Set icon based on volume level
case "$VOLUME" in
  [6-9][0-9]|100) ICON="󰕾" ;;
  [3-5][0-9]) ICON="󰖀" ;;
  [1-9]|[1-2][0-9]) ICON="󰕿" ;;
  *) ICON="󰖁" ;;
esac

# Check if muted
MUTED=$(osascript -e "output muted of (get volume settings)")
if [ "$MUTED" = "true" ]; then
  ICON="󰖁"
  COLOR="$RED"
else
  COLOR="$ICON_COLOR"
fi

sketchybar --set "$NAME" \
           icon="$ICON" \
           icon.color="$COLOR" \
           label="$VOLUME%"
