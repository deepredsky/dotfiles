set -gx EDITOR vim
set -gx FORWARDS true
set -gx JAVA_HOME (/usr/libexec/java_home)
set -gx GOPATH ~/dev/go
set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'

alias be="bundle exec"
alias b="bundle"
alias s="bundle exec rails s"
alias c="bundle exec rails c"
alias gd="git diff"
alias l="ls -l"
alias tmux="env TERM=xterm-256color tmux"

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_cleanstate '✔'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '…'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '⇡'
set __fish_git_prompt_char_upstream_behind '⇣'
set ___fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_showcolorhints 'yes'

function fish_greeting
end

function fish_prompt_cwd
  if test $PWD = $HOME
    echo "~"
  else
    echo (basename $PWD)
  end
end

function _prompt_color_for_status
  if test $argv[1] -eq 0
    echo green
  else
    echo red
  end
end

function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (fish_prompt_cwd)
  set_color normal

  printf ' %s' (__fish_git_prompt '%s ')

  set_color (_prompt_color_for_status $last_status)
  printf "❯ "

  set_color normal
end

function g --wraps=git
    if count $argv > /dev/null
        command git $argv
    else
        command git status
    end
end

function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
end
set -g fish_key_bindings hybrid_bindings

set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
set PATH /usr/local/sbin $PATH
set PATH $HOME/.bin $PATH
rbenv rehash >/dev/null ^&1
status --is-interactive; and source (rbenv init -|psub)
