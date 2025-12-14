#!/usr/bin/env bash

# Set CONFIG_DIR if not set
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

source "$CONFIG_DIR/current-theme"

# Function to update monitor highlighting
update_monitor_highlighting() {
    local active_monitor_idx="$1"
    
    # Check if we're in single monitor mode (workspaces_single exists)
    if sketchybar --query "workspaces_single" >/dev/null 2>&1; then
        # Single monitor mode - just highlight the single workspace group
        sketchybar --set "workspaces_single" \
                   background.border_color="$TEXT_HIGHLIGHT_COLOR" \
                   background.border_width=3
        return
    fi
    
    # Multi-monitor mode - Update all monitor sections (0, 1, 2 max)
    for i in {0..2}; do
        # Check if monitor section exists
        if sketchybar --query "workspaces_monitor_$i" >/dev/null 2>&1; then
            if [ "$i" = "$active_monitor_idx" ]; then
                # Active monitor - highlight
                sketchybar --set "workspaces_monitor_$i" \
                           background.border_color="$TEXT_HIGHLIGHT_COLOR" \
                           background.border_width=3
                           
                # Also highlight the monitor label if it exists
                if sketchybar --query "monitor_label_$i" >/dev/null 2>&1; then
                    sketchybar --set "monitor_label_$i" \
                               label.color="$TEXT_HIGHLIGHT_COLOR" \
                               background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
                               background.border_color="$TEXT_HIGHLIGHT_COLOR"
                fi
            else
                # Inactive monitor - normal
                sketchybar --set "workspaces_monitor_$i" \
                           background.border_color="$SECTION_BORDER_COLOR" \
                           background.border_width=1
                           
                # Normal monitor label
                if sketchybar --query "monitor_label_$i" >/dev/null 2>&1; then
                    sketchybar --set "monitor_label_$i" \
                               label.color="$TEXT_COLOR" \
                               background.color="$ITEM_BG_COLOR" \
                               background.border_color="$SECTION_BORDER_COLOR"
                fi
            fi
        fi
    done
}

# Handle different events
case "$1" in
    "highlight")
        update_monitor_highlighting "$2"
        ;;
    *)
        # Default: try to determine active monitor from focused workspace
        if command -v aerospace >/dev/null 2>&1; then
            FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)
            if [ -n "$FOCUSED_WS" ]; then
                # Updated workspace mapping based on actual usage:
                # LG (monitor 0): A-E, 6-9, F-S  
                # Retina (monitor 1): 1-5, T-Z
                if [[ "$FOCUSED_WS" =~ ^[A-E]$ ]] || [[ "$FOCUSED_WS" =~ ^[6-9]$ ]] || [[ "$FOCUSED_WS" =~ ^[F-S]$ ]]; then
                    update_monitor_highlighting "0"
                elif [[ "$FOCUSED_WS" =~ ^[1-5]$ ]] || [[ "$FOCUSED_WS" =~ ^[T-Z]$ ]]; then
                    update_monitor_highlighting "1"
                fi
            fi
        fi
        ;;
esac