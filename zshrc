export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$HOME/bin:$PATH
export EDITOR=vim
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

ZSH=$HOME/.oh-my-zsh

autoload -U zmv

ZSH_THEME="deepredsky"

unsetopt correct_all

DISABLE_CORRECTION="true"

alias be="bundle exec"
alias b="bundle"

plugins=(git bundler brew gem)

source $ZSH/oh-my-zsh.sh
