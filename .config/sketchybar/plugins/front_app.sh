#!/usr/bin/env bash

source "$CONFIG_DIR/current-theme"

if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  # Truncate app name if too long
  app_name="$INFO"
  if [ ${#app_name} -gt 20 ]; then
    app_name="${app_name:0:17}..."
  fi

  sketchybar --set "$NAME" \
             label="$app_name" \
             background.drawing=on \
             background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
             background.corner_radius="$ITEM_CORNER_RADIUS" \
             background.padding_left=4 \
             background.padding_right=4
fi
