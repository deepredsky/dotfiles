ZSH=$HOME/.oh-my-zsh
ZSH_THEME="deepredsky"

unsetopt correct_all

DISABLE_CORRECTION="true"

plugins=(git bundler brew gem)

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export EDITOR=vim

source $ZSH/oh-my-zsh.sh
