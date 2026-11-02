# AeroSpace Cheatsheet

Stow links this repo's `aerospace/.aerospace.toml` to `~/.aerospace.toml`.
Run `aerospace reload-config` after editing it.

Hyper means **Command + Control + Option + Shift**. In Raycast's Hyper Key
settings, map Caps Lock to Hyper with **Include Shift** enabled. Hold Caps Lock
while pressing the other key. Keep Raycast running and reserve the Hyper
combinations below for AeroSpace. See the [setup steps](../README.md#raycast-and-hyper-key).

## App Launch

| Keybind           | Action        |
| ----------------- | ------------- |
| `Alt + Enter`     | Open Terminal |
| `Alt + Shift + O` | Open Obsidian |
| `Alt + Shift + S` | Open Safari   |

## Focus Navigation

| Keybind          | Action              |
| ---------------- | ------------------- |
| `Alt + H`        | Focus left          |
| `Alt + J`        | Focus down          |
| `Alt + K`        | Focus up            |
| `Alt + L`        | Focus right         |
| `Alt + Ctrl + H` | Focus left monitor  |
| `Alt + Ctrl + L` | Focus right monitor |

## Accordion Navigation

Switch between overlapping windows using the same focus keys as tiles. The
focused window expands; use the keys that match the accordion's orientation.

| Keybind | Action |
| --- | --- |
| `Alt + H` / `Alt + L` | Previous/next window in a horizontal accordion |
| `Alt + K` / `Alt + J` | Previous/next window in a vertical accordion |
| `Hyper + L` | Toggle horizontal/vertical orientation |
| `Hyper + Tab` | Toggle accordion/tiles |
| `Alt + ,` | Switch to accordion and toggle its orientation |

Leave Shift out when switching windows: `Alt + Shift + H/J/K/L` moves windows.
See [AeroSpace accordion layouts](https://nikitabobko.github.io/AeroSpace/guide#layouts).

## Move Windows

| Keybind           | Action                            |
| ----------------- | --------------------------------- |
| `Alt + Shift + H` | Move window left                  |
| `Alt + Shift + J` | Move window down                  |
| `Alt + Shift + K` | Move window up                    |
| `Alt + Shift + L` | Move window right                 |
| `Alt + Shift + N` | Move window to next workspace     |
| `Alt + Shift + P` | Move window to previous workspace |

## Layouts & Window Grouping

| Keybind                          | Action                                   |
| -------------------------------- | ---------------------------------------- |
| `Alt + /`                        | Tiles layout (horizontal ↔ vertical)     |
| `Alt + ,`                        | Accordion layout (horizontal ↔ vertical) |
| `Alt + Shift + 5 (%)`            | Tiles vertical                           |
| `Alt + Shift + " (quote)`        | Tiles horizontal                         |
| `Alt + Shift + ]`                | Join with right                          |
| `Alt + Shift + [`                | Join with left                           |
| `Alt + Shift + U`                | Flatten workspace tree (ungroup windows) |
| `Alt + Shift + F`                | Toggle fullscreen                        |
| `Hyper + F`   | Layout floating ↔ tiling                 |
| `Hyper + Tab` | Layout tiles ↔ accordion                 |
| `Hyper + L`   | Layout horizontal ↔ vertical             |

## Resize Windows

| Keybind           | Action           |
| ----------------- | ---------------- |
| `Alt + Shift + -` | Resize smart -50 |
| `Alt + Shift + =` | Resize smart +50 |

## Workspace Navigation

| Keybind             | Workspace                                    |
| ------------------- | -------------------------------------------- |
| `Alt + 1 → Alt + 3` | Workspace 1 → 3                              |
| `Alt + 9`           | Workspace 9 (assigned to built-in display)              |
| `Alt + A/B/C/D/M/O/R/S/T/V` | Switch to that letter workspace                |
| `Alt + Tab` or `Hyper + N` | Workspace back-and-forth                     |
| `Alt + Shift + Tab` | Move workspace to next monitor (wrap-around) |

## Move Window to Workspace

| Keybind                               | Action                            |
| ------------------------------------- | --------------------------------- |
| `Hyper + 1 → 3, 9` | Move window to workspace 1–3 or 9 and follow it |
| `Hyper + A/B/C/D/M/O/R/S/T/V`    | Move window to that letter workspace and follow it    |

## Service Mode

| Keybind | Action |
| --- | --- |
| `Alt + Shift + ;` or `Hyper + Q` | Enter service mode |
| `Esc` (in service mode) | Reload AeroSpace config and return to main mode |
| `R` (in service mode) | Flatten workspace tree and return to main mode |

These service-mode actions do not reload SketchyBar. Use `Hyper + X` for both.

## Reload / Notifications

| Keybind                        | Action                                                              |
| ------------------------------ | ------------------------------------------------------------------- |
| `Hyper + X` | Reload Aerospace config, reload Sketchybar, show macOS notification |

## On Window Detected Rules
Automatically move windows to workspaces:

| App      | App ID                | Workspace |
| -------- | --------------------- | --------- |
| Obsidian | md.obsidian           | O         |
| Ghostty  | com.mitchellh.ghostty | T         |
| Safari   | com.apple.Safari      | S         |

