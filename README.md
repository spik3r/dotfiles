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

Load Homebrew, clone the `main` branch, and install the apps and CLI tools.
You can keep the checkout anywhere; leave it in place after linking the configs.

```bash
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
git clone --branch main https://github.com/spik3r/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
brew bundle
./stow_all.sh
brew services start sketchybar
brew services start borders
```

The Brewfile grants package-level trust only to Borders, SketchyBar, and
AeroSpace from their third-party taps.

The script checks for app-config and other Zsh conflicts before making backups.
Existing `~/.zshrc` and `~/.zprofile` files or links from another setup are moved
to a private, timestamped directory under `~/.local/state/dotfiles/backups/`.
It prints each backup path. Links already pointing to this checkout are kept;
re-running the installer does not create another backup of them.

To restore a backup, remove the corresponding Stow link and move the backed-up
file to its original path. Merge any settings you need into the new setup first.
Existing `~/omz-custom`, `~/.aerospace.toml`, or app configs
under `~/.config` still cause the installer to stop with a conflict. Back up and
merge those paths yourself, then rerun the script. Directories at `~/.zshrc` or
`~/.zprofile` also require manual resolution.

The script can also be called by absolute path from another directory.
Only `.aerospace.toml` is linked from `aerospace/`; the cheatsheet stays in the
repo. If an earlier install created `~/cheatsheet.md`, remove it only after
checking that it is a symlink to this repo.

The tracked `.gitconfig` is deliberately excluded. The optional Git setup below
adds profile routing without replacing your work Mac's Git config.

Stow links `.zprofile`, `.zshrc`, and `~/omz-custom`.
The custom `kai` theme is included at `~/omz-custom/themes/kai.zsh-theme`.
`.zshrc` contains the interactive shell setup.
Open a new login shell after installation.

When upgrading from the split config, the installer removes an old
`~/.zshrc.local` symlink only if it points to this checkout. It leaves regular
files and links to other locations untouched, but no longer loads them. Move
machine-specific exports from those files into `~/.zshenv`.

Optional Oh My Zsh install:

```bash
KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

`~/.zshrc` loads Oh My Zsh with the included `kai` theme if Oh My Zsh
is installed, then loads fzf, zoxide, autosuggestions, and syntax highlighting.

## Shell startup and local environment

The installer creates `~/.zshenv` with owner-only read/write permissions when
it is missing. It never replaces an existing file or symlink, and does not link
this file into the repo. Keep machine-specific exports there, for example:

```zsh
export EDITOR="vim"
export VISUAL="vim"
export PROJECTS_DIR="$HOME/code"
```

Zsh automatically reads `~/.zshenv` before `.zprofile` and `.zshrc`; sourcing it
again from `.zshrc` would execute it twice. It also runs for non-interactive Zsh
scripts, so keep it quiet and avoid aliases, prompts, or commands that need a TTY.
The editor and locale defaults in `.zshrc` preserve values already set by
`.zshenv` or the parent environment.

- `.zprofile` runs for login shells. It finds Homebrew in `/opt/homebrew` on Apple
  Silicon or `/usr/local` on Intel and loads its PATH and environment settings.
  Keep this step for a new Mac: finding Homebrew's directory alone does not add
  its executables to PATH. Interactive non-login shells inherit that environment
  from their parent login shell, including Zellij panes. Launch Zellij from that
  initialized terminal; `.zshrc` does not detect or initialize Homebrew again.
- `.zshrc` runs for interactive shells. It defaults `XDG_CONFIG_HOME` to
  `~/.config` only when unset and contains the aliases, theme, history, and tool setup.

## Git identities and SSH keys

Run this from the checkout to enable the profiles, or to update an older setup:

```bash
./setup_git.sh
```

The installer Stows `git/.config/git/dotfiles.inc` to
`~/.config/git/dotfiles.inc` and adds one include to your global Git config.
It backs up an existing global config under `~/.local/state/dotfiles/backups/`
before adding that include. Other settings and credential helpers stay in place.
If an older install linked the global config into a checkout, the script replaces
that link with a private local copy before adding the include. The main
`stow_all.sh` does not enable this optional setup.

Only the repository directory selects the profile. There are no GitHub or GitLab
host rules:

| Local identity file | Used for | SSH key |
| --- | --- | --- |
| `~/.gitconfig-personal` | `~/code/personal/` and its subdirectories | `~/.ssh/id_ed25519_personal` |
| `~/.gitconfig-work` | Everywhere else, including GitHub and GitLab | `~/.ssh/id_ed25519` |

The installer creates missing profile files with owner-only permissions and
empty name and email fields. Fill these in once using emails verified by the
corresponding accounts:

```bash
git config --file ~/.gitconfig-personal user.name "YOUR NAME"
git config --file ~/.gitconfig-personal user.email "PERSONAL_EMAIL"
git config --file ~/.gitconfig-work user.name "YOUR NAME"
git config --file ~/.gitconfig-work user.email "WORK_EMAIL"
```

Empty profiles block commits until configured. Existing readable files or links
to files are preserved; broken links and directories stop setup for you to resolve.
Local identity files and SSH keys stay outside the repository.

When upgrading, the shared config loads your existing work identity and then
sets `id_ed25519` as the default key. This overrides the old work profile's
`id_ed25519_work` command without editing that file. The personal template
continues to use `id_ed25519_personal`. If you previously customized its SSH
command, set it back once:

```bash
git config --file ~/.gitconfig-personal core.sshCommand \
  'ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes'
```

Re-running the installer preserves identities and does not duplicate its global
include. Old profile files from the earlier host-based setup remain untouched
but are no longer included, except for the personal and work files above.

### Clone with the right account

Use normal SSH URLs; both GitHub accounts work without SSH host aliases:

```bash
mkdir -p ~/code/personal ~/code/work
git clone git@github.com:PERSONAL_USER/dotfiles.git ~/code/personal/dotfiles
git clone git@github.com:WORK_ORG/PROJECT.git ~/code/work/PROJECT
git clone git@gitlab.com:WORK_GROUP/PROJECT.git ~/code/work/GITLAB_PROJECT
```

Replace the capitalized names. Clone dotfiles only if you do not already have a
checkout. The directory rule applies during cloning and to new repositories
before they have a remote. It works with any hostname, including self-hosted
GitLab. Repositories under `~/code/personal/` always select the personal profile,
even for a GitLab remote. All other locations select the default profile, even
for GitHub. Keep the checkout in place after Stow creates its links.

To bootstrap before the installer is available, clone over HTTPS or select the
personal key for that command:

```bash
git -c core.sshCommand="ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes" \
  clone git@github.com:spik3r/dotfiles.git ~/code/personal/dotfiles
```

HTTPS uses a credential helper rather than an SSH key. Switch an existing
checkout to SSH once if needed:

```bash
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
```

Commit identity and login credentials are separate; an email alone does not
select an account. Repository-local settings and command-line overrides take
precedence over the global profiles. Linked Git worktrees follow their Git
directory, which can be in the original checkout; do not use a linked worktree's
location to switch accounts.

### Create and register SSH keys

Check for existing keys first. Reuse `~/.ssh/id_ed25519` for your default/work
account and `~/.ssh/id_ed25519_personal` for your personal account if they already
exist. Otherwise, run only the missing key commands, choose passphrases, and
decline any overwrite prompt:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -C "personal" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "work" -f ~/.ssh/id_ed25519
```

Copy the personal **public** key and add it to your personal GitHub account:

```bash
pbcopy < ~/.ssh/id_ed25519_personal.pub
```

Then copy the default public key and add it to your work GitHub and GitLab
accounts:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Never upload the files without `.pub`. If your work organization requires SSO,
authorize the work key for that organization too.

On macOS, store each key's passphrase in Keychain:

```bash
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Merge this into `~/.ssh/config` without replacing existing settings. Put it before
broader `Host *` rules that set these options. Add your actual hostname if GitLab
is self-hosted. It loads keys on demand after login; Git selects each key by
repository directory.

```sshconfig
Host github.com gitlab.com
    AddKeysToAgent yes
    UseKeychain yes
```

Test each account. GitHub reports successful authentication but exits with status
1 because it provides no shell. Check the greeting names the expected account,
and verify the host fingerprint against the provider's docs before accepting it:

```bash
ssh -T -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes git@github.com
ssh -T -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes git@github.com
ssh -T -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes git@gitlab.com
```

Inside personal and other checkouts, check the selected settings:

```bash
git config --show-origin --get user.email
git config --show-origin --get core.sshCommand
git ls-remote origin
```

An existing `[credential] helper` or `gh auth git-credential` entry handles HTTPS
authentication, not commit identity. It is unused for SSH remotes and can stay
if other repositories need it. Do not put tokens in these config files.

References: [Git conditional includes](https://git-scm.com/docs/git-config#_conditional_includes),
[GitHub SSH setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent),
and [GitLab SSH setup](https://docs.gitlab.com/user/ssh/).

## Included

- AeroSpace: `~/.aerospace.toml`
- Borders: `~/.config/borders/bordersrc`
- Ghostty: `~/.config/ghostty/config`
- Hammerspoon: `~/.hammerspoon/init.lua`
- LazyGit: `~/.config/lazygit/config.yml`
- LazyVim: `~/.config/nvim`
- SketchyBar: `~/.config/sketchybar`
- Zellij: `~/.config/zellij/config.kdl`
- Zsh interactive setup: `~/.zshrc`
- Oh My Zsh custom theme: `~/omz-custom/themes/kai.zsh-theme`

## After Install

- Grant Accessibility permissions to AeroSpace, SketchyBar, and Borders in macOS Settings.
- Open Hammerspoon, grant Accessibility permission, and enable **Launch Hammerspoon
  at login** in its preferences. Use **Reload Config** from its menu after changes.
- Open AeroSpace once and grant its requested permissions. AeroSpace starts at login.
- Homebrew services start SketchyBar and Borders at login; AeroSpace does not launch them.
  Check them with `brew services list`. If migrating from the old startup setup,
  quit any manually started SketchyBar and Borders processes before starting their services.
- Run `nvim` once so LazyVim can install plugins.
- Run `zellij` to start the terminal multiplexer.
- Install Obsidian separately if you use the `Alt-Shift-o` app shortcut. It is optional.

## Raycast and Hyper key

Raycast is included in the Brewfile. On an existing installation, run:

```bash
brew bundle
open -a Raycast
```

In Raycast, enable launch at login and grant its requested macOS permissions.
Open **Settings → Keyboard → Hyper Key** (search Settings for Hyper Key if your
version uses a different menu). Select **Caps Lock** and enable **Include Shift**.
This config uses Hyper as **Control + Option + Command + Shift**; leaving Shift
off will not match the AeroSpace bindings. Optionally set Quick Press to Escape.
Keep Raycast running for the remapping to work, and disable other tools that
remap Caps Lock. These settings are configured in Raycast, not by Stow.

Do not assign Raycast hotkeys to the Hyper combinations reserved for AeroSpace
in the table below. If Hyper stops working, check Raycast's Hyper Key diagnostic
and whether an app has enabled Secure Input. Its compatibility option only
supports Raycast's own shortcuts while Secure Input is active, so AeroSpace
shortcuts can still be blocked. See the [Raycast Hyper Key manual](https://manual.raycast.com/hyper-key).

## AeroSpace setup and shortcuts

`./stow_all.sh` links `aerospace/.aerospace.toml` to `~/.aerospace.toml`.
Open AeroSpace and grant Accessibility access when prompted. It starts at login;
SketchyBar and Borders run through the Homebrew services started during install.
Raycast supplies the Hyper key; AeroSpace handles the window commands directly.
No Raycast extension is needed for these bindings.

After editing the linked config, reload it:

```bash
aerospace reload-config
```

| Shortcut | Action |
| --- | --- |
| `Alt-h/j/k/l` | Focus left/down/up/right |
| `Alt-Shift-h/j/k/l` | Move the window left/down/up/right |
| `Alt-1/2/3/9` | Switch to that workspace |
| `Alt-a/b/c/d/m/o/r/s/t/v` | Switch to the corresponding letter workspace |
| `Hyper-1/2/3/9` or `Hyper-a/b/c/d/m/o/r/s/t/v` | Move the window to that workspace and follow it |
| `Hyper-f` | Toggle floating/tiling |
| `Hyper-Tab` | Toggle tiles/accordion |
| `Hyper-l` | Toggle horizontal/vertical layout |
| `Hyper-n` | Switch to the previous workspace |
| `Hyper-q` | Enter service mode; `Esc` reloads and exits, `r` flattens and exits |
| `Hyper-x` | Reload AeroSpace and SketchyBar |

Try `Caps Lock + t`: it moves the focused window to workspace T and follows it.
Ghostty windows also open on T automatically; Safari uses S and Obsidian uses O.
`Alt-Enter` opens Apple's Terminal app. See the [full cheatsheet](aerospace/cheatsheet.md)
for the remaining resize, layout, and monitor commands.

Check monitor names with `aerospace list-monitors`. The config assigns workspace
9 to `Built-in Retina Display` and uses monitor-specific top gaps: 44 for
`built-in.*`, 76 for `LG.*`, and 76 as the fallback. Adjust those values and the
workspace assignment for your displays, then reload. Review the macOS settings
below too. See the [AeroSpace configuration guide](https://nikitabobko.github.io/AeroSpace/guide#configuring-aerospace).

AeroSpace uses `Alt-h/j/k/l` to focus windows and `Alt-Shift-h/j/k/l` to move
them. These global bindings take precedence over terminal applications. Neovim
provides `Space m j` / `Space m k` to move lines or visual selections down / up;
Zellij uses the `Ctrl-b` prefix below for pane navigation.

## Hammerspoon clipboard

Install or update with `brew bundle` and `./stow_all.sh`, then open Hammerspoon.
The installer stops if an existing Hammerspoon config conflicts; back it up and
merge it before rerunning.
Machine-specific shortcuts can live in `~/.hammerspoon/init.local.lua`; the
tracked config loads that file when present. Keep it outside the repo.

Cmd-C, Cmd-X, and Cmd-V keep their normal behaviour. Ctrl-V inserts the previous
copied or cut text as plain text without changing the system clipboard. For
example, copy `foo`, then `bar`: Cmd-V pastes `bar`, Ctrl-V inserts `foo`, and
Cmd-V still pastes `bar`. Repeated Ctrl-V inserts `foo` again.

The two most recent text copies stay in memory only and reset on config reload
or exit. Images and files are not stored in the second slot. Clipboard changes
are checked every 0.1 seconds; copies made faster than that may be missed.
Ctrl-V applies globally, replacing app bindings such as terminal quoted insert
and Neovim visual block mode while Hammerspoon is running. macOS Secure Input
can prevent the shortcut from working.

## Zellij

Zellij uses a `Ctrl-b` prefix. It starts in Normal mode with the inherited
keybindings cleared, so `Ctrl-h`, `Ctrl-s`, `Ctrl-o`, `Ctrl-n`, `Ctrl-p`, and
`Ctrl-q` reach the application. Tmux mode is active only after the prefix.

Press `Ctrl-b`, release it, then press:

| Key | Action |
| --- | --- |
| `"` / `%` | Split below / right |
| `h/j/k/l` or arrows | Focus a pane |
| `H/J/K/L` | Grow a pane in that direction |
| `o` | Switch to the previous pane |
| `c` | Create a tab |
| `n` / `p` / `1`–`9` | Next / previous / numbered tab |
| `,` | Rename the tab; `Enter` saves, `Esc` cancels |
| `z` | Toggle pane fullscreen |
| `Space` | Cycle pane layouts |
| `[` | Enter scrollback; `j/k` scroll, `/` searches, `q` or `Esc` exits |
| `s` | Open the session manager |
| `x` | Close the pane and its running process |
| `d` | Detach and leave the session running |
| `Ctrl-b` | Send a literal `Ctrl-b` to the application |
| `Esc` | Cancel the prefix |

Most commands return to Normal mode. In scrollback search, use `n` / `N` for
next / previous matches. Zellij reserves no unprefixed Alt shortcuts; AeroSpace
still handles its global Alt bindings before keys reach the terminal.
Start a new Zellij session to verify the new defaults; an existing session may
keep its current input mode when the config reloads.

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
