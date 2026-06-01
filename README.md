# Dotfiles

Lean macOS setup using GNU Stow.

## Install

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle
./stow_all.sh
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
- Git: `~/.gitconfig`
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
