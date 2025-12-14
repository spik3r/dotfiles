#!/usr/bin/env bash

# Set CONFIG_DIR if not set
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

source "$CONFIG_DIR/current-theme"

WORKSPACE="$1"
MONITOR_IDX="$2"

# Use existing theme colors
MONITOR_COLORS=("$ITEM_BG_COLOR" "$ITEM_BG_COLOR" "$ITEM_BG_COLOR")
MONITOR_BORDER_COLORS=("$SECTION_BORDER_COLOR" "$SECTION_BORDER_COLOR" "$SECTION_BORDER_COLOR")
MONITOR_HIGHLIGHT_COLORS=("$ITEM_BG_COLOR_HIGHLIGHT" "$ITEM_BG_COLOR_HIGHLIGHT" "$ITEM_BG_COLOR_HIGHLIGHT")
MONITOR_TEXT_COLORS=("$TEXT_COLOR" "$TEXT_COLOR" "$TEXT_COLOR")

if [ "$SENDER" = "aerospace_workspace_change" ]; then
    # Get the monitor index from the item name if not provided
    if [ -z "$MONITOR_IDX" ]; then
        if [[ "$NAME" =~ workspace\.([0-9]+)\. ]]; then
            MONITOR_IDX="${BASH_REMATCH[1]}"
        else
            MONITOR_IDX=0
        fi
    fi
    
    # Get focused workspace from aerospace
    CURRENT_FOCUSED=""
    if command -v aerospace >/dev/null 2>&1; then
        CURRENT_FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
    fi
    
    # Also check if this workspace has windows
    HAS_WINDOWS=false
    if command -v aerospace >/dev/null 2>&1; then
        WINDOW_COUNT=$(aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | wc -l)
        if [ "$WINDOW_COUNT" -gt 0 ]; then
            HAS_WINDOWS=true
        fi
    fi
    
    # Update workspace appearance
    if [ "$WORKSPACE" = "$CURRENT_FOCUSED" ]; then
        # Highlight active workspace
        sketchybar --set "$NAME" \
                   label.color="$TEXT_HIGHLIGHT_COLOR" \
                   background.drawing=on \
                   background.height="$ITEM_HEIGHT" \
                   background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
                   background.border_color="$TEXT_HIGHLIGHT_COLOR" \
                   background.border_width=2
    elif [ "$HAS_WINDOWS" = true ]; then
        # Workspace has windows but isn't focused - subtle highlight
        sketchybar --set "$NAME" \
                   label.color="$TEXT_COLOR" \
                   background.drawing=on \
                   background.height="$ITEM_HEIGHT" \
                   background.color="$ITEM_BG_COLOR_HIGHLIGHT" \
                   background.border_color="$SECTION_BORDER_COLOR" \
                   background.border_width=1
    else
        # Normal workspace appearance
        sketchybar --set "$NAME" \
                   label.color="$TEXT_COLOR" \
                   background.drawing=on \
                   background.height="$ITEM_HEIGHT" \
                   background.color="$ITEM_BG_COLOR" \
                   background.border_color="$SECTION_BORDER_COLOR" \
                   background.border_width=1
    fi

    # Update monitor highlighting if in multi-monitor mode
    if [ -n "$MONITOR_IDX" ] && [ "$MONITOR_IDX" != "0" ] || sketchybar --query "workspaces_monitor_0" >/dev/null 2>&1; then
        # Multi-monitor mode: get focused monitor from aerospace
        FOCUSED_MONITOR=""
        if command -v aerospace >/dev/null 2>&1 && [ -n "$CURRENT_FOCUSED" ]; then
            # Find which monitor has the focused workspace
            MONITORS=($(aerospace list-monitors 2>/dev/null))
            for mon_idx in "${!MONITORS[@]}"; do
                monitor="${MONITORS[$mon_idx]}"
                MONITOR_WS=($(aerospace list-workspaces --monitor "$monitor" 2>/dev/null))
                if [[ " ${MONITOR_WS[*]} " =~ " $CURRENT_FOCUSED " ]]; then
                    FOCUSED_MONITOR="$mon_idx"
                    break
                fi
            done
        fi
        
        if [ -n "$FOCUSED_MONITOR" ]; then
            "$PLUGIN_DIR/monitor_manager.sh" highlight "$FOCUSED_MONITOR"
        fi
    fi

    # Trigger workspace apps update when workspace changes
    sketchybar --trigger workspace_apps_changed
fi
