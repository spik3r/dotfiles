#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
command -v git >/dev/null
command -v stow >/dev/null

# Fail before creating files if the existing global config cannot be read.
git config --list >/dev/null
for profile in personal work; do
  target="$HOME/.gitconfig-$profile"
  if [[ ( -e "$target" || -L "$target" ) && ( ! -f "$target" || ! -r "$target" ) ]]; then
    echo "Expected a readable file at $target; resolve this path first." >&2
    exit 1
  fi
done

mkdir -p "$HOME/.config"
stow --simulate --no-folding -d "$repo_dir" -t "$HOME" git

include="$HOME/.config/git/dotfiles.inc"
installed=false
if git config --global --fixed-value --get-all include.path "$include" >/dev/null; then
  installed=true
fi

global_config="${GIT_CONFIG_GLOBAL:-$HOME/.gitconfig}"
if [[ -z "${GIT_CONFIG_GLOBAL:-}" && ! -e "$global_config" && -e "${XDG_CONFIG_HOME:-$HOME/.config}/git/config" ]]; then
  global_config="${XDG_CONFIG_HOME:-$HOME/.config}/git/config"
fi
if [[ "$installed" == false && -e "$global_config" ]]; then
  backup_root="$HOME/.local/state/dotfiles/backups"
  backup_dir="$(umask 077; mkdir -p "$backup_root"; mktemp -d "$backup_root/git-$(date +%Y%m%d-%H%M%S).XXXXXX")"
  (umask 077; cp -L "$global_config" "$backup_dir/.gitconfig")
  echo "Backed up $global_config to $backup_dir/.gitconfig"
fi

# Old installs may link the global config into a checkout. Make it local before
# Git writes to it, so machine-specific include paths never enter that checkout.
if [[ -L "$global_config" ]]; then
  local_copy="$(umask 077; mktemp "${global_config}.XXXXXX")"
  trap 'rm -f "$local_copy"' EXIT
  cat "$global_config" > "$local_copy"
  mv -f "$local_copy" "$global_config"
  trap - EXIT
  echo "Replaced the global config symlink with a private local copy."
fi

for profile in personal work; do
  target="$HOME/.gitconfig-$profile"
  if [[ ! -e "$target" && ! -L "$target" ]]; then
    (umask 077; set -o noclobber; cat "$repo_dir/git-templates/$profile" > "$target")
    echo "Created $target; fill in its name and email."
  fi
done

stow --no-folding -d "$repo_dir" -t "$HOME" git
if [[ "$installed" == false ]]; then
  git config --global --add include.path "$include"
fi
echo "Git profiles linked. See README.md for identities, SSH keys, and checks."
