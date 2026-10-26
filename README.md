# Dotfiles

Lean macOS setup using GNU Stow.

## Install

Install the Xcode Command Line Tools first and wait for the installer to finish:

```bash
xcode-select --install
```

Install Homebrew if it is not already installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Load Homebrew, clone the `cleanup` branch, and install the apps and CLI tools.
You can keep the checkout anywhere; leave it in place after linking the configs.

```bash
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
git clone --branch cleanup https://github.com/spik3r/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
brew bundle
./stow_all.sh
brew services start sketchybar
brew services start borders
```

The script checks all packages for conflicts before linking any files. It stops
if an existing file or directory would be overwritten. Back up each conflicting
path shown by Stow, merge any settings you need, then rerun the script. For example,
if `~/.zprofile` already exists, move it to an unused backup path:

```bash
mv -i "$HOME/.zprofile" "$HOME/.zprofile.before-dotfiles"
./stow_all.sh
```

Do not overwrite an existing backup. Apply the same process to conflicts in
`~/.zshrc`, `~/.zshrc.local`, `~/.aerospace.toml`, or individual app directories
under `~/.config`. Re-running the script after a completed install is safe.
The script can also be called by absolute path from another directory.
Only `.aerospace.toml` is linked from `aerospace/`; the cheatsheet stays in the
repo. If an earlier install created `~/cheatsheet.md`, remove it only after
checking that it is a symlink to this repo.

`.gitconfig` is deliberately excluded. Keep your work Mac's Git identity and
credential settings separate; configure them locally if needed.

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
- Open AeroSpace once and grant its requested permissions. AeroSpace starts at login.
- Homebrew services start SketchyBar and Borders at login; AeroSpace does not launch them.
  Check them with `brew services list`. If migrating from the old startup setup,
  quit any manually started SketchyBar and Borders processes before starting their services.
- Run `nvim` once so LazyVim can install plugins.
- Run `zellij` to start the terminal multiplexer.

## Neovim

LazyVim provides completion, navigation, diagnostics, and format-on-save.
Language extras are declared in `.config/nvim/lua/config/lazy.lua`; local
overrides live in `.config/nvim/lua/plugins/lang.lua`.

| Language | Language server | Formatting |
| --- | --- | --- |
| Go | gopls | goimports, gofumpt |
| Java | Eclipse JDTLS through nvim-jdtls | JDTLS |
| C# / F# | Roslyn / FsAutoComplete | CSharpier / Fantomas |
| JavaScript, TypeScript, React, SolidJS | vtsls, ESLint | Prettier |
| Rust | rust-analyzer through rustaceanvim | rustfmt through the LSP |
| Terraform | terraform-ls | terraform fmt |
| HCL | — | hclfmt |
| Markdown | Marksman | Prettier, markdownlint |
| HTML / CSS | HTML / CSS language servers, Emmet | Prettier |
| Python | Pyright, Ruff | Ruff |

Mason installs editor tools. The Brewfile installs Go, Node, the .NET SDK, and OpenJDK 25.
Install Terraform and a Rust toolchain separately if you use those languages;
include rustfmt and Clippy and keep the tools available in `PATH`. Rust toolchains
are managed by rustup. Project SDK constraints belong in `global.json`,
`rust-toolchain.toml`, and the equivalent language-specific files.

Java support uses LazyVim's Java extra. Mason installs JDTLS; open a Java file
inside a Maven, Gradle, or Git project to start it. The shell selects Homebrew's
OpenJDK 25 when `JAVA_HOME` is unset. Keep an existing `JAVA_HOME` at Java 25 or
newer for the current Mason JDTLS package; project target versions belong in
Maven or Gradle configuration.
Restart the terminal after `brew bundle` so Neovim inherits the Java environment.

C# formatting uses Mason's CSharpier CLI directly, so an older global
`dotnet-csharpier` tool cannot override it. Generic `.hcl` files use Mason's
`hclfmt`; Terraform files keep `terraform fmt`.

React and SolidJS use the same TypeScript server. Solid projects should set
`"jsx": "preserve"` and `"jsxImportSource": "solid-js"` in `tsconfig.json`.
Install each project's dependencies and ESLint plugins locally. Use
`:VenvSelect` to choose a Python virtual environment when needed.

Markdown renders inside Neovim (`<leader>um`); browser Markdown Preview and
Flutter tooling are disabled. Oil opens directory buffers. In normal mode,
`-` opens the parent directory in Oil. `\` toggles the Snacks side explorer
at the project root, as does `<leader>e` (`Space`, then `e`).

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
