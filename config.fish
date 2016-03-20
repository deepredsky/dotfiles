set -gx EDITOR vim
set -gx FORWARDS true

alias be="bundle exec"
alias b="bundle"
alias s="bundle exec rails s"
alias c="bundle exec rails c"
alias gd="git diff"
# alias git="echo NO WAY!"

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
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '%'
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_char_untrackedfiles '%'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  set_color normal
end

function g --wraps=git
    if count $argv > /dev/null
        command git $argv
    else
        command git status
    end
end

fish_vi_mode

set PATH $HOME/.rbenv/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
set PATH $HOME/bin $PATH
rbenv rehash >/dev/null ^&1

set -gx TNS_ADMIN "/usr/local/oracle/network/admin"
set -gx NLS_LANG "AMERICAN_AMERICA.UTF8"
set -gx TWO_TASK SALORMA
set -gx ORACLE_SID SALORMA
set -gx DYLD_FALLBACK_LIBRARY_PATH "/usr/local/opt"

