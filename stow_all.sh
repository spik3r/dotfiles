#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$repo_dir"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required. Run brew bundle in $repo_dir first." >&2
  exit 1
fi

mkdir -p "$HOME/.config"

# Check other conflicts before moving the two shell startup files into backups.
if ! {
  stow --simulate --ignore='^\.(zshrc|zprofile)$' -t "$HOME" zsh &&
  stow --simulate -t "$HOME/.config" .config &&
  stow --simulate --ignore='^cheatsheet\.md$' -t "$HOME" aerospace
}; then
  echo "Resolve the conflicts above, then rerun this script. See README.md for backup steps." >&2
  exit 1
fi

shell_backups=()
for name in .zshrc .zprofile; do
  target="$HOME/$name"
  if [[ -L "$target" && "$target" -ef "$repo_dir/zsh/$name" ]]; then
    continue
  fi
  if [[ -d "$target" && ! -L "$target" ]]; then
    echo "Expected a file at $target; resolve this directory before installing." >&2
    exit 1
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    shell_backups+=("$name")
  fi
done

if [[ ${#shell_backups[@]} -gt 0 ]]; then
  backup_root="$HOME/.local/state/dotfiles/backups"
  backup_dir="$(umask 077; mkdir -p "$backup_root"; mktemp -d "$backup_root/$(date +%Y%m%d-%H%M%S).XXXXXX")"
  for name in "${shell_backups[@]}"; do
    mv "$HOME/$name" "$backup_dir/$name"
    echo "Backed up $HOME/$name to $backup_dir/$name"
  done
fi

# Keep machine-specific exports outside the repository and preserve existing files.
if [[ ! -e "$HOME/.zshenv" && ! -L "$HOME/.zshenv" ]]; then
  (
    umask 077
    set -o noclobber
    cat > "$HOME/.zshenv" <<'ENV'
# Machine-specific environment variables. Keep this file outside Git.
# Zsh loads it automatically before .zprofile and .zshrc, including for scripts.
# Keep it quiet and use export statements rather than interactive shell setup.
# Example: export PROJECTS_DIR="$HOME/code"
ENV
  )
  echo "Created $HOME/.zshenv for local environment variables."
fi

echo "Stowing zsh local setup..."
stow -t "$HOME" zsh

echo "Stowing app configs..."
stow -t "$HOME/.config" .config

echo "Stowing AeroSpace..."
stow --ignore='^cheatsheet\.md$' -t "$HOME" aerospace

# Remove only the obsolete link owned by this checkout, including dangling links.
legacy_rc="$HOME/.zshrc.local"
if [[ -L "$legacy_rc" ]]; then
  legacy_target="$(readlink "$legacy_rc")"
  [[ "$legacy_target" = /* ]] || legacy_target="$HOME/$legacy_target"
  legacy_parent="$(cd -P "$(dirname "$legacy_target")" 2>/dev/null && pwd)" || legacy_parent=""
  if [[ "$legacy_parent" == "$repo_dir/zsh" && "$(basename "$legacy_target")" == .zshrc.local ]]; then
    rm "$legacy_rc"
    echo "Removed obsolete Stow link $legacy_rc."
  fi
fi

echo "Stowing complete. Open a new login shell to load the configuration."
