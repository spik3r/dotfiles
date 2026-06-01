# Dotfiles

Lean macOS setup using GNU Stow.

## Install

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle
./stow_all.sh
brew services start sketchybar
brew services start borders
```

Add this to `~/.zshrc`:

```zsh
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
```

Optional Oh My Zsh install:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

`~/.zshrc.local` will load Oh My Zsh if it exists, then load the fzf, zoxide, autosuggestions, and syntax highlighting setup.

## Included

- AeroSpace: `~/.aerospace.toml`
- Borders: `~/.config/borders/bordersrc`
- Ghostty: `~/.config/ghostty/config`
- LazyGit: `~/.config/lazygit/config.yml`
- LazyVim: `~/.config/nvim`
- SketchyBar: `~/.config/sketchybar`
- Zellij: `~/.config/zellij/config.kdl`
- Zsh local setup: `~/.zshrc.local`

## After Install

- Grant Accessibility permissions to AeroSpace, SketchyBar, and Borders in macOS Settings.
- Start AeroSpace once; it starts SketchyBar and Borders from `after-startup-command`.
- Run `nvim` once so LazyVim can install plugins.
- Run `zellij` to start the terminal multiplexer.

## macOS Settings

- Hide the menu bar: `System Settings > Control Centre > Automatically hide and show the menu bar > Always`.
- AeroSpace windows setting: `System Settings > Desktop & Dock > Mission Control > Displays have separate Spaces > On`.
- Recommended for window managers: `System Settings > Desktop & Dock > Mission Control > Automatically rearrange Spaces based on most recent use > Off`.
- Recommended for window managers: `System Settings > Desktop & Dock > Mission Control > When switching to an application, switch to a Space with open windows for the application > Off`.

Terminal equivalent for hiding the menu bar:

```bash
defaults write NSGlobalDomain _HIHideMenuBar -bool true
killall Finder
```
