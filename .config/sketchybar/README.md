# Sketchybar Configuration

## Theme System

This configuration uses a modular theme system that separates colors from layout/spacing defaults.

### Theme Switching

```bash
# Switch themes
~/.config/sketchybar/switch-theme.sh san-marino-blue
~/.config/sketchybar/switch-theme.sh tokyonight-storm
~/.config/sketchybar/switch-theme.sh catppuccin-mocha

# Show available themes
~/.config/sketchybar/switch-theme.sh
```

### Available Themes

- **tokyonight-storm**: Dark theme with purple/blue accents (default)
- **san-marino-blue**: BMW San Marino blue with cyan highlights
- **catppuccin-mocha**: Popular Catppuccin color scheme

### Creating New Themes

Creating a new theme is simple - just copy the template and change colors:

```bash
# Copy the template
cp ~/.config/sketchybar/themes/TEMPLATE ~/.config/sketchybar/themes/my-theme

# Edit colors in the new file
# Add to switch-theme.sh THEMES array
```

**Template structure:**
- Load base defaults (fonts, spacing, sizes)
- Define your color palette
- Apply colors to bar/item elements
- Optionally override any defaults

### Theme Architecture

- **`defaults`**: Base configuration (fonts, spacing, sizes)
- **`themes/`**: Color-only theme files that inherit defaults
- **`current-theme`**: Symlink to active theme
- **`switch-theme.sh`**: Theme switcher utility

This makes themes lightweight and easy to maintain!

## Features

- **Workspaces**: Aerospace workspace indicators with highlighting
- **Apps**: Shows all apps in current workspace with active app highlighted
- **System Info**: WiFi, Battery (with icon), Volume with click-to-open settings
- **Clock**: Day, date, and time in the rightmost corner
- **Font**: FiraCode Nerd Font throughout
- **Clickable**: All system items open their respective System Preferences