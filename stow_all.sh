#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.config"

echo "Stowing zsh local setup..."
stow -t "$HOME" zsh

echo "Stowing app configs..."
stow -t "$HOME/.config" .config

echo "Stowing AeroSpace..."
stow -t "$HOME" aerospace

echo "Stowing complete. Open a new login shell to load the configuration."
