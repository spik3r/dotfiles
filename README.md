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

Stow links `.zprofile` and `.zshrc`; `.zshrc` loads the local shell setup.
Open a new login shell after installation.

Optional Oh My Zsh install:

```bash
KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

## Neovim

LazyVim provides completion, navigation, diagnostics, and format-on-save.
Language extras are declared in `.config/nvim/lua/config/lazy.lua`; local
overrides live in `.config/nvim/lua/plugins/lang.lua`.

| Language | Language server | Formatting |
| --- | --- | --- |
| Go | gopls | goimports, gofumpt |
| C# / F# | Roslyn / FsAutoComplete | CSharpier / Fantomas |
| JavaScript, TypeScript, React, SolidJS | vtsls, ESLint | Prettier |
| Rust | rust-analyzer through rustaceanvim | rustfmt through the LSP |
| Terraform | terraform-ls | terraform fmt |
| Markdown | Marksman | Prettier, markdownlint |
| HTML / CSS | HTML / CSS language servers, Emmet | Prettier |
| Python | Pyright, Ruff | Ruff |

Mason installs editor tools. Keep Go, Node, the .NET SDK, Terraform, and a
Rust toolchain with rustfmt and Clippy available in `PATH`. Rust toolchains
are managed by rustup. Project SDK constraints belong in `global.json`,
`rust-toolchain.toml`, and the equivalent language-specific files.

React and SolidJS use the same TypeScript server. Solid projects should set
`"jsx": "preserve"` and `"jsxImportSource": "solid-js"` in `tsconfig.json`.
Install each project's dependencies and ESLint plugins locally. Use
`:VenvSelect` to choose a Python virtual environment when needed.

Markdown renders inside Neovim (`<leader>um`); browser Markdown Preview and
Flutter tooling are disabled. Oil opens directory buffers and `-` opens the
parent directory.

Update plugins with `:Lazy update`, restart Neovim, then run `:TSUpdate` and
`:checkhealth`. Use `:Mason` for language-server and formatter updates.
Keep `lazy-lock.json` in Git so plugin revisions can be restored.

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
