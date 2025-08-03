#!/usr/bin/env bash

THEME_DIR="$HOME/.config/sketchybar/themes"
CONFIG_DIR="$HOME/.config/sketchybar"

# Available themes
THEMES=("tokyonight-storm" "san-marino-blue" "catppuccin-mocha")

# Function to display usage
usage() {
    echo "Usage: $0 [theme-name]"
    echo "Available themes:"
    for theme in "${THEMES[@]}"; do
        echo "  - $theme"
    done
    echo ""
    echo "Current theme: $(get_current_theme)"
}

# Function to get current theme
get_current_theme() {
    if [ -L "$CONFIG_DIR/current-theme" ]; then
        basename "$(readlink "$CONFIG_DIR/current-theme")"
    else
        echo "tokyonight-storm"
    fi
}

# Function to switch theme
switch_theme() {
    local theme="$1"
    
    # Check if theme exists
    if [ ! -f "$THEME_DIR/$theme" ]; then
        echo "Error: Theme '$theme' not found!"
        usage
        exit 1
    fi
    
    # Create/update symlink to current theme
    ln -sf "$THEME_DIR/$theme" "$CONFIG_DIR/current-theme"
    
    # Update main config to use current-theme
    sed -i '' 's|themes/[^"]*|current-theme|g' "$CONFIG_DIR/sketchybarrc"
    
    # Update all plugin scripts to use current-theme
    find "$CONFIG_DIR/plugins" -name "*.sh" -exec sed -i '' 's|themes/[^"]*|current-theme|g' {} \;
    
    echo "Switched to theme: $theme"
    echo "Reloading sketchybar..."
    
    # Reload sketchybar
    sketchybar --reload
}

# Main logic
if [ $# -eq 0 ]; then
    usage
    exit 0
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    usage
    exit 0
else
    switch_theme "$1"
fi