set nocompatible hidden laststatus=2

if !filereadable('/tmp/plug.vim')
  silent !curl --insecure -fLo /tmp/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

source /tmp/plug.vim
call plug#begin('/tmp/plugged')
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
call plug#end()

autocmd VimEnter * PlugClean! | PlugUpdate --sync