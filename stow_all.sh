#!/bin/bash

# Stow tmux to the home directory
echo "Stowing tmux..."
stow -t ~ tmux

# Stow zsh to the home directory (for .zshrc and .zprofile)
echo "Stowing zsh..."
stow -t ~ zsh

# Stow neovim (from ~/dotfiles/.config) to ~/.config
echo "Stowing .config..."
stow -t ~/.config .config

# Stow aerospace to the home directory
echo "Stowing aerospace..."
stow -t ~ aerospace

# Stow starship (from ~/dotfiles/starship) to ~/.config
# echo "Stowing starship.."
# stow -t ~/.config starship

echo "Stowing completed!"

