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

Run this once from the checkout to enable automatic profiles:

```bash
./setup_git.sh
```

This Stows `git/.config/git/dotfiles.inc` to `~/.config/git/dotfiles.inc` and adds
one include to your global Git config. It backs up an existing global config
under `~/.local/state/dotfiles/backups/` before changing it. Other settings and
credential helpers stay in place. Re-running it preserves your profile files
and does not add duplicate includes. The main `stow_all.sh` does not enable this
optional setup.
If an older install linked the global config into a checkout, the script
replaces that link with a private local copy before adding the include.

The script creates these private local files with empty name and email fields.
Edit each profile you use; the empty fields prevent commits with an unconfigured
profile. Existing readable files or links to files are preserved; broken links
and directories stop setup for you to resolve. These files and SSH keys are
never linked into the repo. Files from the earlier three-profile setup are
left untouched but are no longer included.

| Local file | Used for | SSH key |
| --- | --- | --- |
| `~/.gitconfig-personal` | GitHub by default; `~/code/personal/` | `~/.ssh/id_ed25519_personal` |
| `~/.gitconfig-work` | GitLab.com by default; everything under `~/code/work/` | `~/.ssh/id_ed25519_work` |

Set the name and verified email in each local file, for example:

```gitconfig
[user]
    name = Your Name
    email = your-verified-email@example.com
    useConfigOnly = true
```

Keep the included `[core] sshCommand` line: it selects that profile's SSH key.
Commit identity and login credentials are separate; an email alone does not
select a GitHub account.

### Work and personal GitHub accounts

Keep both GitHub and GitLab work checkouts under `~/code/work/`. They share
the work identity and SSH key. Keep personal checkouts under `~/code/personal/`.
The directory rule overrides host defaults, so both accounts use normal GitHub
SSH URLs:

```bash
mkdir -p ~/code/personal ~/code/work
git clone git@github.com:PERSONAL_USER/dotfiles.git ~/code/personal/dotfiles
git clone git@github.com:WORK_ORG/PROJECT.git ~/code/work/PROJECT
git clone git@gitlab.com:WORK_GROUP/PROJECT.git ~/code/work/GITLAB_PROJECT
```

Replace the capitalized names. Clone dotfiles only if you do not already have a
checkout. An existing dotfiles checkout can stay anywhere: its GitHub remote
selects the personal profile unless it is inside `~/code/work/`.
Directory rules also apply to new repositories before they have a remote.
After the initial setup, cloning into the right directory selects the commit
identity and SSH key automatically, including during the clone itself.

The host rules cover `git@github.com:…`, `ssh://git@github.com/…`, and HTTPS
URLs, with equivalent rules for GitLab.com. HTTPS selects the commit identity
but uses your credential helper rather than an SSH key. Use SSH URLs for the
two GitHub accounts in this setup. For an existing checkout, switch its URL once:

```bash
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
```

For self-hosted GitLab, keep its checkouts under `~/code/work/`; the directory
rule works with any hostname. Use its actual hostname in the SSH test below.
For other directory layouts, add `includeIf "gitdir:~/your/work/path/"` rules to
your global config after the dotfiles include, pointing at the matching local
profile. A trailing slash includes nested repositories. Repositories outside
these directories with remotes on both hosts match both host defaults; put them
in the appropriate profile directory to resolve that ambiguity.
Existing repository-local settings override these global profiles. Linked Git
worktrees follow their Git directory, which can be in the original checkout;
do not use a worktree's location to switch accounts.

### Create and register SSH keys

Check for existing keys first. Reuse the appropriate key or update the local
profile's `sshCommand` to its filename. If creating keys, run only the commands
for accounts you use, choose passphrases, and decline any overwrite prompt:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -C "personal" -f ~/.ssh/id_ed25519_personal
ssh-keygen -t ed25519 -C "work" -f ~/.ssh/id_ed25519_work
```

Copy each **public** key and add it to its matching account's SSH keys settings:

```bash
pbcopy < ~/.ssh/id_ed25519_personal.pub
# Add this key to your personal GitHub account, then copy the next key.
pbcopy < ~/.ssh/id_ed25519_work.pub
# Add this work key to both your work GitHub and GitLab accounts.
```

Never upload the files without `.pub`. If your work organization requires SSO,
authorize the work key for that organization too.

On macOS, store each key's passphrase in Keychain:

```bash
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519_personal
/usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519_work
```

Merge this into `~/.ssh/config` without replacing existing settings. Put it before
broader `Host *` rules that set these options. It loads keys on demand after login;
the Git profile still chooses the key for each repository.

```sshconfig
Host github.com gitlab.com
    AddKeysToAgent yes
    UseKeychain yes
```

Test each account (GitHub reports successful authentication but exits with status
1 because it provides no shell). Check the greeting names the expected account,
and verify the host fingerprint against the provider's docs before accepting it:

```bash
ssh -T -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes git@github.com
ssh -T -i ~/.ssh/id_ed25519_work -o IdentitiesOnly=yes git@github.com
ssh -T -i ~/.ssh/id_ed25519_work -o IdentitiesOnly=yes git@gitlab.com
```

Inside a personal and a work checkout, check the selected settings:

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
- LazyGit: `~/.config/lazygit/config.yml`
- LazyVim: `~/.config/nvim`
- SketchyBar: `~/.config/sketchybar`
- Zellij: `~/.config/zellij/config.kdl`
- Zsh interactive setup: `~/.zshrc`
- Oh My Zsh custom theme: `~/omz-custom/themes/kai.zsh-theme`

## After Install

- Grant Accessibility permissions to AeroSpace, SketchyBar, and Borders in macOS Settings.
- Open AeroSpace once and grant its requested permissions. AeroSpace starts at login.
- Homebrew services start SketchyBar and Borders at login; AeroSpace does not launch them.
  Check them with `brew services list`. If migrating from the old startup setup,
  quit any manually started SketchyBar and Borders processes before starting their services.
- Run `nvim` once so LazyVim can install plugins.
- Run `zellij` to start the terminal multiplexer.
- Install Obsidian separately if you use the `Alt-Shift-o` app shortcut. It is optional.

AeroSpace uses `Alt-h/j/k/l` to focus windows and `Alt-Shift-h/j/k/l` to move
them. These global bindings take precedence over terminal applications. Neovim
provides `Space m j` / `Space m k` to move lines or visual selections down / up;
Zellij uses the `Ctrl-b` prefix below for pane navigation.

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
