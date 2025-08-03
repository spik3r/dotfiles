#!/usr/bin/env bash

source "$CONFIG_DIR/current-theme"

if [ "$SENDER" = "aerospace_workspace_change" ]; then
    if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
        # Highlight active workspace
        sketchybar --set "$NAME" \
                   label.color="$TEXT_HIGHLIGHT_COLOR" \
                   background.drawing=on \
                   background.height=30 \
                   background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
                   background.border_color="$ITEM_BG_COLOR_HIGHLIGHT"
    else
        # Normal workspace appearance
        sketchybar --set "$NAME" \
                   label.color="$TEXT_COLOR" \
                   background.drawing=off
    fi

    # Trigger workspace apps update when workspace changes
    sketchybar --trigger workspace_apps_changed
fi
