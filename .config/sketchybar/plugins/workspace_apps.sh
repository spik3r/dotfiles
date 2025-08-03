#!/usr/bin/env bash

source "$HOME/.config/sketchybar/current-theme"

# Get current workspace apps
WORKSPACE_APPS=($(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null | sort -u))
FRONT_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

# Create display string with apps, highlighting the active one
DISPLAY_APPS=""
ACTIVE_FOUND=false

for app in "${WORKSPACE_APPS[@]}"; do
    if [ ! -z "$app" ]; then
        # Truncate long app names
        SHORT_APP=$(echo "$app" | cut -c1-10)
        if [ "$app" = "$FRONT_APP" ]; then
            # Mark active app (will be highlighted with background)
            DISPLAY_APPS="$DISPLAY_APPS $SHORT_APP"
            ACTIVE_FOUND=true
        else
            DISPLAY_APPS="$DISPLAY_APPS $SHORT_APP"
        fi
    fi
done

# Clean up leading space
DISPLAY_APPS=$(echo "$DISPLAY_APPS" | sed 's/^ *//')

# Update the item with highlighting
if [ ! -z "$DISPLAY_APPS" ]; then
    if [ "$ACTIVE_FOUND" = true ]; then
        # Highlight exactly like active workspace
        sketchybar --set "$NAME" \
                   label="$DISPLAY_APPS" \
                   label.color="$TEXT_HIGHLIGHT_COLOR" \
                   background.drawing=on \
                   background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
                   background.border_color="$TEXT_HIGHLIGHT_COLOR"
    else
        # Normal appearance like inactive workspace
        sketchybar --set "$NAME" \
                   label="$DISPLAY_APPS" \
                   label.color="$TEXT_COLOR" \
                   background.drawing=off
    fi
else
    sketchybar --set "$NAME" label="No Apps"
fi