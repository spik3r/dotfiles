# kai — path from afowler, git block from robbyrussell, arrow from nicoulaj.
#
# Renders as:   ~/dotfiles/zsh git:(main ) ❯
#
# Colours are 256-colour approximations of Tokyo Night Storm, to match the
# Ghostty theme:
#   117 cyan #7dcfff   111 blue #7aa2f7   149 green #9ece6a
#   210 red  #f7768e   179 yellow #e0af68  141 purple #bb9af7
#
# Nerd Font glyphs, so this needs a patched font (FiraCode Nerd Font here).
# Leading glyph is the Apple logo, nf-fa-apple (U+F179). To go back to the
# terminal icon, replace it on the PROMPT line with nf-fa-terminal (U+F120):
#   PROMPT='%F{141}\uf120%f  %F{149}...
# Other options: U+E795 rounded terminal, U+F489 oct-terminal, U+F135 rocket.
# The dirty marker is nf-fa-bolt (U+F0E7); U+2717 is the plain robbyrussell x.

PROMPT='%F{141}%f  %F{149}%3~%f $(git_prompt_info)%(?.%F{149}.%F{210})❯%f '

# Exit code on the right, only when the last command failed.
RPROMPT='%(?..%F{210}%? ↵%f)'

ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{111}git:(%b%F{210}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{179}%B%F{111})%b%f"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%F{111})%b%f"
