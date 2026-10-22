#!/usr/bin/env bash

source "$HOME/.config/sketchybar/current-theme"

PERCENTAGE="$(pmset -g batt | grep -Eo "\\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

# Set icon based on battery level (Mac-like horizontal battery)
case "${PERCENTAGE}" in
  9[0-9]|100) ICON="󰁹" ;;
  [7-8][0-9]) ICON="󰂂" ;;
  [5-6][0-9]) ICON="󰂁" ;;
  [3-4][0-9]) ICON="󰂀" ;;
  [1-2][0-9]) ICON="󰁿" ;;
  *) ICON="󰁺" ;;
esac

# Override icon if charging
if [[ "$CHARGING" != "" ]]; then
  ICON="󰢝"
fi

# Set color based on battery level
if [ "$PERCENTAGE" -le 20 ] && [[ "$CHARGING" == "" ]]; then
  COLOR="0xfff7768e"
elif [ "$PERCENTAGE" -le 50 ]; then
  COLOR="0xffe0af68"
else
  COLOR="0xff7dcfff"
fi

sketchybar --set "$NAME" \
           icon="$ICON" \
           icon.color="$COLOR" \
           label="${PERCENTAGE}%"
