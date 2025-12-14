#!/usr/bin/env bash

# Set CONFIG_DIR if not set
if [ -z "$CONFIG_DIR" ]; then
    CONFIG_DIR="$(dirname "$(dirname "$0")")"
fi

source "$CONFIG_DIR/current-theme"

# Configure sketchybar per display
configure_displays() {
    # Get display count
    DISPLAY_COUNT=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -c "Display Type" || echo "1")
    
    if [ "$DISPLAY_COUNT" -gt 1 ]; then
        # Multi-monitor setup - configure for LG display needs
        
        # Get current display arrangement
        DISPLAY_INFO=$(system_profiler SPDisplaysDataType 2>/dev/null)
        
        if echo "$DISPLAY_INFO" | grep -q "LG"; then
            # LG display detected - add 1/3 more spacing than Retina defaults
            # Retina defaults: margin=8, padding=12, y_offset=8, height=56
            # LG (1/3 more): margin=11, padding=16, y_offset=11, height=75
            sketchybar --bar \
                margin=11 \
                padding_left=16 \
                padding_right=16 \
                y_offset=11 \
                height=75
        fi
    else
        # Single monitor - use default spacing
        sketchybar --bar \
            margin="$BAR_MARGIN" \
            padding_left="$BAR_PADDING" \
            padding_right="$BAR_PADDING" \
            y_offset="$BAR_Y_OFFSET" \
            height="$BAR_HEIGHT"
    fi
}

# Run configuration
configure_displays