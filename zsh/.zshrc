# Interactive shell configuration.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

if [[ -r "$HOME/dotfiles/zsh/.zshrc.local" ]]; then
  source "$HOME/dotfiles/zsh/.zshrc.local"
fi
