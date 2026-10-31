#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

if [[ -n "$1" ]]; then
    "$CONFIG_DIR/switch-theme.sh" "$1"
else
    sketchybar --set theme_switcher popup.drawing=toggle
fi
