#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required. Run brew bundle in $repo_dir first." >&2
  exit 1
fi

mkdir -p "$HOME/.config"

# Check every package before installing links so a conflict leaves no partial setup.
if ! {
  stow --simulate -t "$HOME" zsh &&
  stow --simulate -t "$HOME/.config" .config &&
  stow --simulate --ignore='^cheatsheet\.md$' -t "$HOME" aerospace
}; then
  echo "Resolve the conflicts above, then rerun this script. See README.md for backup steps." >&2
  exit 1
fi

echo "Stowing zsh local setup..."
stow -t "$HOME" zsh

echo "Stowing app configs..."
stow -t "$HOME/.config" .config

echo "Stowing AeroSpace..."
stow --ignore='^cheatsheet\.md$' -t "$HOME" aerospace

echo "Stowing complete. Open a new login shell to load the configuration."
