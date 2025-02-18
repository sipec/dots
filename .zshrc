export CLICOLOR=1

local HOMEBREW_PREFIX=/opt/homebrew
export FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"

source $HOMEBREW_PREFIX/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# source $HOMEBREW_PREFIX/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh 

# show path and git branch
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
PROMPT='%D{%m-%d %H:%M} %2~ > '
zstyle ':vcs_info:git:*' formats '%F{blue}%b%f %r'

#  zsh-autocomplete
# # make Enter submit the command line straight from the menu
# bindkey -M menuselect '\r' .accept-line
# # make ← and → always move the cursor on the command line
# # bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
# # bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char
# zstyle ':autocomplete:recent-paths:*' list-lines 10
# zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 10
# zstyle ':autocomplete:history-search-backward:*' list-lines 8
# zstyle ':autocomplete:*' min-input 1
# zstyle ':autocomplete:*' insert-unambiguous yes
# zstyle ':autocomplete:*' widget-style menu-select
# zstyle ':completion:*' menu select
# zstyle ':completion:*' complete-options true

alias k='kubectl'

# bun completions
# [ -s "/Users/clarity/.bun/_bun" ] && source "/Users/clarity/.bun/_bun"

source <(fzf --zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse"

# up arrow key will search history if buffer is empty
up-line-or-search-prefix() {
    if [ -z $BUFFER ]; then
        BUFFER="$(fc -ln 1 | fzf --layout=default --no-sort +m --tac --bind 'start:pos(1)')"
        CURSOR=$#BUFFER
        zle redisplay
    else
        zle up-line-or-search
    fi
}
zle -N up-line-or-search-prefix
bindkey "^[[A" up-line-or-search-prefix  # Up arrow key

source $HOMEBREW_PREFIX/opt/autoenv/activate.sh

# stop myself from using yarn global
yarn() {
  if [[ "$1" == "global" ]]; then
    echo "⛔️ yarn global is disabled!"
    echo "💡 Try using bun instead:"
    echo "    bun install -g ${@:3}"
    return 1
  fi
  command yarn "$@"
}

. "$HOME/.local/bin/env"

[[ -f ~/.inshellisense/zsh/init.zsh ]] && source ~/.inshellisense/zsh/init.zsh