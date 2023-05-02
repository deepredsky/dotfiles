set -gx EDITOR vim -u ~/.vimrc_minimal
set -gx FORWARDS true
set -gx GOPATH ~/dev/go
set -gx HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK 1
set -gx FZF_DEFAULT_COMMAND 'fd --type=file --hidden --exclude .git'
set -gx MANPAGER "col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -"

alias be="bundle exec"
alias b="bundle"
alias s="bundle exec rails s"
alias c="bundle exec rails c"
alias gd="git diff"
alias l="ls -l"
alias tmux="env TERM=xterm-256color tmux"
alias k="kubectl"

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

# Fish git prompt
set __fish_git_prompt_showdirtystate yes
set __fish_git_prompt_showstashstate yes
set __fish_git_prompt_showuntrackedfiles yes
set __fish_git_prompt_showupstream auto
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⌾'
set __fish_git_prompt_char_cleanstate '✔'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '…'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '⇡'
set __fish_git_prompt_char_upstream_behind '⇣'
set ___fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_showcolorhints yes

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
    if count $argv >/dev/null
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

function fish_mode_prompt
end

set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
set PATH $HOME/.bin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.cabal/bin $PATH
set PATH /usr/local/sbin $PATH
set -gx TERMINFO_DIRS $HOME/.local/share/terminfo $TERMINFO_DIRS
fish_add_path /opt/homebrew/bin

function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

function fco -d "Fuzzy-find and checkout a branch"
    git branch --all | grep -v HEAD | string trim | fzf | xargs echo | sed -E s_remotes/origin/__g | xargs git checkout
end

function fdb -d "Fuzzy-find and force delete a branch"
    git branch | grep -v '*' | string trim | fzf -m --reverse | xargs echo | sed -E 's/^[[:space:]]*//g' | xargs git branch -D
end

function t -d "Edit todos"
    vim -u ~/.vimrc_minimal ~/notes/Todos.md -c ':Goyo'
end

function n -d "Edit note"
    vim -u ~/.vimrc_minimal ~/notes/scratch.md -c ':Goyo'
end

function j -d "Edit today's journal"
    vim -u ~/.vimrc_minimal ~/notes/diary/(date "+%Y-%m-%d").md -c ':Goyo'
end

function ns -d "Fuzzy-find a note"
    vim -u ~/.vimrc_minimal (fd '.md' ~/notes | string trim | fzf) -c ':lcd ~/notes' -c ':Goyo'
end

if test -f $HOME/.local.fish
    source $HOME/.local.fish
end

function cleanup_dead_docker -d "Remove dead docker images"
    docker ps --filter status=dead --filter status=exited | awk '/weeks ago/ { print $1 }' | xargs docker rm -v

    docker volume ls -qf "dangling=true" | egrep -v "^$_" | xargs docker volume rm

    docker images -qf "dangling=true" | egrep -v "^$_" | xargs docker rmi -f
end

function apps -d "Fuzzy-find and open apps"
    kubectl get ing -o jsonpath='{range .items[*]}{.spec.rules[0].host}{"\n"}{end}' | fzf | xargs -I % open "https://%"
end

function ssh_pods -d "Fuzzy-find ssh pods"
    kubectl get pods -o name | cut -d/ -f2 | fzf | xargs -o -I % kubectl exec -it % -c app -- bash
end

function theme-switch -d "Switch tmux theme"
    if test "$argv[1]" = light
        echo -e "\033Ptmux;\033\033]1337;SetProfile=light\007\a\033\\"
        touch /tmp/light-theme
        if tmux info &>/dev/null
            tmux source-file ~/.tmux/light.conf
        end
    else
        echo -e "\033Ptmux;\033\033]1337;SetProfile=dark\007\a\033\\"
        rm -f /tmp/light-theme
        if tmux info &>/dev/null
            tmux source-file ~/.tmux/dark.conf
        end
    end

    if tmux info &>/dev/null
        for session in (tmux list-sessions -F '#{session_id}')
            for window in (tmux list-windows -t "$session" -F '#{window_index}')
                for pane in (tmux list-panes -t "$session:$window" -F "#{pane_index}")
                    set -l pix "$session:$window.$pane"
                    set -l is_vim "ps -o state= -o comm= -t '#{pane_tty}'  | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?\$'"
                    tmux if-shell -t "$pix" "$is_vim" "send-keys -t $pix escape ENTER"
                    tmux if-shell -t "$pix" "$is_vim" "send-keys -t $pix ':call UpdateBackground()' ENTER"
                end
            end
        end
    end
end

function jira -d "Open vim jira"
    vi +JiraSprint
end

export GPG_TTY=$(tty)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /usr/local/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
