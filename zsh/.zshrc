# ~/.zshrc configuration file for macOS

# Set the default editor (use your favorite editor, e.g., 'vim' or 'nano')
export VISUAL=nvim
export EDITOR=nvim

# # Enable command autocompletion
# autoload -U compinit
# compinit
#
# # Enable command correction
# setopt correct_all
#
# # Enable case-insensitive globbing
# setopt nocaseglob

# Enable Starship prompt
eval "$(starship init zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Enable zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# chruby https://jekyllrb.com/docs/installation/macos/
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
# Aliases (you can add more as you like)
# alias ll="ls -la"
# alias gs="git status"
# alias gco="git checkout"
# alias gc="git commit"

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias vk='NVIM_APPNAME=nvim-kickstart nvim' # Kickstart
alias va='NVIM_APPNAME=nvim-ai nvim' # Claude generated config

# # Set the default prompt for when Starship is not available (just in case)
# if [[ ! -f ~/.config/starship.toml ]]; then
#   export PS1='%n@%m %~ %# '
# fi

# Set the default Zsh history file
export HISTFILE=~/.zsh_history

# Set the history size and options
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_all_dups    # Ignore duplicate history entries
setopt hist_ignore_space      # Ignore commands starting with a space
setopt hist_find_no_dups      # Do not show duplicates when searching history

# # Custom prompt, you can modify as you like
# PROMPT='%n@%m:%~ %# '

export TERM="screen-256color"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="/opt/homebrew/opt/dotnet@8/bin:$PATH"

export EDITOR=nvim

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.1 # run chruby to see actual version
eval "$(zoxide init zsh)"
export PATH="$HOME/go/bin:$PATH"
