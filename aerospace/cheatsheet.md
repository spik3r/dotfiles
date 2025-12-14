# AeroSpace Cheatsheet

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
| `Cmd + Ctrl + Alt + Shift + F`   | Layout floating ↔ tiling                 |
| `Cmd + Ctrl + Alt + Shift + Tab` | Layout tiles ↔ accordion                 |
| `Cmd + Ctrl + Alt + Shift + L`   | Layout horizontal ↔ vertical             |

## Resize Windows
| Keybind           | Action           |
| ----------------- | ---------------- |
| `Alt + Shift + -` | Resize smart -50 |
| `Alt + Shift + =` | Resize smart +50 |

## Workspace Navigation
| Keybind             | Workspace                                    |
| ------------------- | -------------------------------------------- |
| `Alt + 1 → Alt + 3` | Workspace 1 → 3                              |
| `Alt + 9`           | Workspace 9 (secondary monitor)              |
| `Alt + A → Alt + V` | Workspace A → V (custom apps)                |
| `Alt + Tab`         | Workspace back-and-forth                     |
| `Alt + Shift + Tab` | Move workspace to next monitor (wrap-around) |

## Move Window to Workspace
| Keybind                               | Action                            |
| ------------------------------------- | --------------------------------- |
| `Cmd + Ctrl + Alt + Shift + 1 → 3, 9` | Move window to workspace 1 → 3, 9 |
| `Cmd + Ctrl + Alt + Shift + A → V`    | Move window to workspace A → V    |

## Service Mode
| Keybind                        | Action                                  |
| ------------------------------ | --------------------------------------- |
| `Alt + Shift + ;`              | Enter service mode + trigger sketchybar |
| `Cmd + Alt + Ctrl + Shift + Q` | Enter service mode + trigger sketchybar |
| Keybind | Action                                                         |
## Service Mode Bindings
| Keybind | Action                                                         |
| ------- | -------------------------------------------------------------- |
| `Esc`   | Reload config + exit service mode + update sketchybar          |
| `R`     | Flatten workspace tree + exit service mode + update sketchybar |

## Reload / Notifications
| Keybind                        | Action                                                              |
| ------------------------------ | ------------------------------------------------------------------- |
| `Cmd + Ctrl + Alt + Shift + X` | Reload Aerospace config, reload Sketchybar, show macOS notification |

## On Window Detected Rules
Automatically move windows to workspaces:
| App      | App ID                | Workspace |
| -------- | --------------------- | --------- |
| Obsidian | md.obsidian           | O         |
| Ghostty  | com.mitchellh.ghostty | T         |
| Safari   | com.apple.Safari      | S         |

