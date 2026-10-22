#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$(dirname "$(dirname "$0")")}"
source "$CONFIG_DIR/current-theme"

# Keep one predictable bar geometry across displays. AeroSpace owns the window
# gap; SketchyBar only needs to be compact and visually consistent.
sketchybar --bar \
  margin="$BAR_MARGIN" \
  padding_left="$BAR_PADDING" \
  padding_right="$BAR_PADDING" \
  y_offset="$BAR_Y_OFFSET" \
  height="$BAR_HEIGHT"
