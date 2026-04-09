export LANG=en_US.UTF-8

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git web-search alias-finder)

source $ZSH/oh-my-zsh.sh

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export VISUAL='nvim'
  export EDITOR='vim'
fi

# Shell options
set -o vi
setopt CORRECT_ALL

# Tools
eval "$(zoxide init zsh)"
eval $(thefuck --alias)

# Docker completions
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Dotfiles management
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Source additional config
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"

# Random greeting
if [[ -f "$HOME/.zsh_greetings" ]]; then
  greetings=("${(@f)$(< "$HOME/.zsh_greetings")}")
  if [[ ${#greetings} -gt 0 ]]; then
    greeting="${greetings[RANDOM % ${#greetings} + 1]}"
    echo "\e[38;2;97;175;239m${greeting}\e[0m" # OneDark Blue #61afef
  fi
fi

# Machine-specific config (not tracked)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
