#!/usr/bin/env bash

# Set CONFIG_DIR if not already set
if [[ -z "$CONFIG_DIR" ]]; then
    CONFIG_DIR="/Users/kaitait/dotfiles/.config/sketchybar"
fi

source "$CONFIG_DIR/environment"

# Get current theme name
CURRENT_THEME=$(basename "$(readlink "$CONFIG_DIR/current-theme")" 2>/dev/null || echo "unknown")

# Function to update the theme switcher display
update_display() {
    # Keep label as "Theme" instead of showing current theme name
    sketchybar --set theme_switcher label="Theme"
}

# Function to cycle through themes
cycle_theme() {
    # Get all available themes
    local themes=()
    for theme_file in "$CONFIG_DIR/themes"/*; do
        if [[ -f "$theme_file" && "$(basename "$theme_file")" != "TEMPLATE" ]]; then
            themes+=("$(basename "$theme_file")")
        fi
    done
    
    # Sort themes alphabetically
    IFS=$'\n' themes=($(sort <<<"${themes[*]}"))
    unset IFS
    
    # Find current theme index
    local current_index=0
    for i in "${!themes[@]}"; do
        if [[ "${themes[$i]}" == "$CURRENT_THEME" ]]; then
            current_index=$i
            break
        fi
    done
    
    # Get next theme (cycle back to first if at end)
    local next_index=$(( (current_index + 1) % ${#themes[@]} ))
    local next_theme="${themes[$next_index]}"
    
    # Switch to next theme
    "$CONFIG_DIR/switch-theme.sh" "$next_theme"
    
    # Reload sketchybar to apply new theme (this will recreate all items)
    sketchybar --reload
}

# Handle different events
case "$SENDER" in
    "routine"|"forced")
        # Update display to show "Theme"
        update_display
        ;;
    "mouse.clicked")
        # Cycle to next theme on click
        cycle_theme
        ;;
    *)
        # Check if called with cycle argument (from click_script)
        if [[ "$1" == "cycle" ]]; then
            cycle_theme
        else
            # Default: just update display
            update_display
        fi
        ;;
esac