export CLICOLOR=1

local HOMEBREW_PREFIX=/opt/homebrew
export FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"

source $HOMEBREW_PREFIX/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# show path and git branch
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
PROMPT='%D{%m-%d %H:%M} %2~ > '
zstyle ':vcs_info:git:*' formats '%F{blue}%b%f %r'

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