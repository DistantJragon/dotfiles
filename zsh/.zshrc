#!/usr/bin/env zsh

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit && compinit

eval "$(zoxide init zsh)"
# For completions to work,
# the above line must be added after compinit is called.
# You may have to rebuild your completions cache by running
# rm ~/.zcompdump*; compinit.

# Make run-help work with builtins instead of acting like man.
# Alias help to run-help.
unalias run-help
autoload run-help
HELPDIR=/usr/share/zsh/${ZSH_VERSION}/help
alias help='run-help'

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

typeset -A ZSH_HIGHLIGHT_STYLES

# Set all "correct" styles to white,
# so that they don't get colored differently from the default text.
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
ZSH_HIGHLIGHT_STYLES[command]='fg=white'
ZSH_HIGHLIGHT_STYLES[function]='fg=white'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white'

alias make="make -j`nproc`"
alias ninja="ninja -j`nproc`"

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS

source "$HOME/.config/djn-zsh/functions.zsh"
source "$HOME/.config/djn-zsh/prompt.zsh"
DJN_MAX_SHORTENED_CWD_LENGTH=25
DJN_MAX_GIT_HEAD_DISPLAY_LENGTH=15
chpwd() {
  djn-shorten-cwd
  djn-detect-git
}
chpwd


precmd() {
  local last_exit_code=$?
  djn-git-check-branch
  djn-git-check-ahead-behind
  djn-git-check-dirty
  djn-reset-last-exit-code "$last_exit_code"
  djn-prompt-cmd
}

# If ~/.config/djn-zsh/functions dir has files, add to fpath and autoload them.
if [[ -d "$HOME/.config/djn-zsh/functions" ]]; then
  fpath=("$HOME/.config/djn-zsh/functions" $fpath)
  for func_file in "$HOME/.config/djn-zsh/functions"/*(.N); do
    autoload -Uz "$(basename "$func_file")"
  done
fi

eval "$(zoxide init --cmd cd zsh)"
