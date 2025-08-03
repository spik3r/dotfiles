#!/usr/bin/env bash

# Theme menu popup handler using SketchyBar native popups
CONFIG_DIR="/Users/kaitait/dotfiles/.config/sketchybar"
source "$CONFIG_DIR/environment"

# Function to switch theme
switch_theme() {
    local selected_theme="$1"
    local current_theme=$(basename "$(readlink "$CONFIG_DIR/current-theme")" 2>/dev/null || echo "unknown")
    
    # Only switch if different theme selected
    if [[ "$selected_theme" != "$current_theme" ]]; then
        # Switch to selected theme
        "$CONFIG_DIR/switch-theme.sh" "$selected_theme"
        
        # Source the new theme to get updated colors
        source "$CONFIG_DIR/current-theme"
        
        # Update bar colors
        sketchybar --bar color="$BAR_COLOR" border_color="$BAR_BORDER_COLOR"
        
        # Update all workspace colors in the correct order
        WORKSPACES=(1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
        for workspace in "${WORKSPACES[@]}"; do
            # Only update if workspace exists
            if sketchybar --query "workspace.$workspace" >/dev/null 2>&1; then
                sketchybar --set "workspace.$workspace" \
                           background.color="$ITEM_BG_COLOR" \
                           background.border_color="$ITEM_BORDER_COLOR" \
                           label.color="$TEXT_COLOR"
            fi
        done
        
        # Update workspaces bracket (if exists)
        sketchybar --set workspaces \
                   background.color="$ITEM_BG_COLOR" \
                   background.border_color="$ITEM_BORDER_COLOR" 2>/dev/null
        
        # Update workspace apps (if exists)
        sketchybar --set workspace_apps \
                   background.color="$ITEM_BG_COLOR" \
                   background.border_color="$ITEM_BORDER_COLOR" \
                   label.color="$TEXT_COLOR" 2>/dev/null
        
        # Update system group (if exists)
        sketchybar --set system_group \
                   background.color="$ITEM_BG_COLOR" \
                   background.border_color="$ITEM_BORDER_COLOR" 2>/dev/null
        
        # Update theme switcher colors (keep label as "Theme")
        sketchybar --set theme_switcher \
                   background.color="$ITEM_BG_COLOR" \
                   background.border_color="$ITEM_BORDER_COLOR" \
                   icon.color="$ICON_COLOR" \
                   label.color="$TEXT_COLOR" \
                   label="Theme" 2>/dev/null
        
        # Update individual system items colors (if they exist)
        sketchybar --set wifi icon.color="$ICON_COLOR" 2>/dev/null
        sketchybar --set battery icon.color="$ICON_COLOR" label.color="$TEXT_COLOR" 2>/dev/null
        sketchybar --set volume icon.color="$ICON_COLOR" label.color="$TEXT_COLOR" 2>/dev/null
        sketchybar --set clock icon.color="$ICON_COLOR" label.color="$TEXT_COLOR" 2>/dev/null
        
        # Update popup theme items to reflect new current theme
        update_popup_themes
        
        # Trigger workspace update to refresh active workspace highlighting
        sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
        
        echo "Switched to theme: $selected_theme"
    fi
    
    # Close the popup
    sketchybar --set theme_switcher popup.drawing=off
}

# Function to update popup theme items
update_popup_themes() {
    local current_theme=$(basename "$(readlink "$CONFIG_DIR/current-theme")" 2>/dev/null || echo "unknown")
    
    # Source current theme for colors
    source "$CONFIG_DIR/current-theme"
    
    # Get all available themes
    for theme_file in "$CONFIG_DIR/themes"/*; do
        if [[ -f "$theme_file" && "$(basename "$theme_file")" != "TEMPLATE" ]]; then
            theme_name=$(basename "$theme_file")
            
            # Update the popup item appearance based on whether it's current
            if [[ "$theme_name" == "$current_theme" ]]; then
                sketchybar --set "theme_popup.$theme_name" \
                           icon="●" \
                           icon.color="$ICON_COLOR" \
                           label.color="$ICON_COLOR" 2>/dev/null
            else
                sketchybar --set "theme_popup.$theme_name" \
                           icon="○" \
                           icon.color="$TEXT_COLOR" \
                           label.color="$TEXT_COLOR" 2>/dev/null
            fi
        fi
    done
}

# Handle different events - always toggle popup if no theme specified
if [[ -n "$1" ]]; then
    # Theme selection
    switch_theme "$1"
else
    # Toggle popup visibility
    sketchybar --set theme_switcher popup.drawing=toggle
    update_popup_themes
fi