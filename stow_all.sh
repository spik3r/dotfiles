#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.config"

echo "Stowing zsh local setup..."
stow -t "$HOME" zsh

echo "Stowing git config..."
stow -t "$HOME" git

echo "Stowing app configs..."
stow -t "$HOME/.config" .config

echo "Stowing AeroSpace..."
stow -t "$HOME" aerospace

echo "Stowing complete. Add this to ~/.zshrc if it is not already present:"
echo '[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"'
