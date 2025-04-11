zparseopts -D -E -- f=fast

export EDITOR=micro
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

alias tf="tofu"
alias k='kubectl'

# bun completions
# [ -s "/Users/clarity/.bun/_bun" ] && source "/Users/clarity/.bun/_bun"

if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
else
  echo "brew-wrap not installed"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height ~40% --layout=reverse --bind 'tab:accept'"

up-line-or-search-prefix() {
  if [ -z "$BUFFER" ]; then
    local FZF_CTRL_R_OPTS="--layout=default --height ~12"
    zle fzf-history-widget
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

if [[ -f ~/.inshellisense/zsh/init.zsh ]]; then
  if [[ ! $fast ]]; then
    source ~/.inshellisense/zsh/init.zsh
  fi
else
  echo "inshellisense not installed"
fi
