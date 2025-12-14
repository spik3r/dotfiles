#!/usr/bin/env bash

# Set CONFIG_DIR if not set
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

source "$CONFIG_DIR/current-theme"

# This script runs on every workspace change to update monitor highlighting

# Get currently focused workspace
if command -v aerospace >/dev/null 2>&1; then
    FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)
else
    FOCUSED_WS="$FOCUSED_WORKSPACE"
fi

# Determine which monitor should be highlighted
# LG (monitor 0): A-E, 6-9, F-S  
# Retina (monitor 1): 1-5, T-Z
if [[ "$FOCUSED_WS" =~ ^[A-E]$ ]] || [[ "$FOCUSED_WS" =~ ^[6-9]$ ]] || [[ "$FOCUSED_WS" =~ ^[F-S]$ ]]; then
    ACTIVE_MONITOR_IDX=0  # LG
else
    ACTIVE_MONITOR_IDX=1  # Retina
fi

# Update monitor highlighting
"$PLUGIN_DIR/monitor_manager.sh" highlight "$ACTIVE_MONITOR_IDX"