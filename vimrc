let g:vimwiki_map_prefix = ',v'

" Plugins {{{
call plug#begin('~/.vim/plugged')

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Trigger configuration.
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']


Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tmhedberg/matchit'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'

" Vim Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rake'
Plug 'deepredsky/vim-rubocop'

" View helpers
Plug 'tpope/vim-haml'
Plug 'slim-template/vim-slim'
Plug 'yaymukund/vim-rabl'
Plug 'elzr/vim-json'

" Git helpers
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
let g:gist_post_private = 1 " make private gist by default

Plug 'tpope/vim-dispatch'
Plug 'rhysd/git-messenger.vim'
Plug 'jgdavey/tslime.vim'

" Autocompletion helpers

Plug 'lifepillar/vim-mucomplete'

  "{{{ Config 'lifepillar/vim-mucomplete'
  set completeopt+=menuone,noselect
  let g:mucomplete#enable_auto_at_startup = 1
  let g:mucomplete#chains = { 'default': [ 'c-p' ] }

  " Prevent µcomplete from mapping <c-h>
  imap <plug>Unused <plug>(MUcompleteCycBwd)

  "}}}

Plug 'mileszs/ack.vim'

"{{{ Config 'mileszs/ack.vim'
if executable('rg')
  set grepprg=rg\ --vimgrep
  let g:ackprg = 'rg --vimgrep'
elseif executable('ag')
  set grepprg=ag\ --vimgrep
  let g:ackprg = 'ag --vimgrep'
endif
"}}}

command! -bang -nargs=* -complete=file Ag           call ack#Ack('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file AgFromSearch call ack#AckFromSearch('grep<bang>', <q-args>)

Plug 'rhysd/committia.vim'

Plug 'elixir-lang/vim-elixir'
Plug 'fatih/vim-go'

Plug 'janko-m/vim-test'

" Better search handling
Plug 'junegunn/vim-slash'

Plug 'walm/jshint.vim'
Plug 'logico-dev/typewriter'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'AndrewRadev/splitjoin.vim'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

let g:prettier#config#semi = 'false'

" ES2015 code snippets (Optional)
Plug 'epilande/vim-es2015-snippets'

" React code snippets
Plug 'epilande/vim-react-snippets'

" React html snippets
Plug 'cristianoliveira/vim-react-html-snippets'

Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Haskell
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'mpickering/hlint-refactor-vim', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }

" Improved UI
Plug 'flazz/vim-colorschemes'
Plug 'lifepillar/vim-solarized8'
Plug 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \   'active': {
      \     'left': [ [ 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype' ] ]
      \   },
      \ }


Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'nightsense/snow'

Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'}]


Plug 'FooSoft/vim-argwrap'
Plug 'tyrannicaltoucan/vim-quantum'

Plug 'ElmCast/elm-vim'
let g:elm_setup_keybindings = 0

Plug 'romainl/vim-qf'

Plug 'deepredsky/vim-pivotal'
Plug 'dag/vim-fish'

call plug#end()
" }}}

" Basic Setup {{{

let mapleader = ","

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " indent slim two spaces, not four
  autocmd! FileType *.slim set sw=2 sts=2 et
augroup END


set nocompatible      " Use vim, no vi defaults
set relativenumber    " Show line numbers
set number            " Show line numbers
set ruler             " Show line and column number
set colorcolumn=80

set termguicolors

" enable 24 bit color support
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

if !has('nvim')
  set viminfo='10,\"100,:20,%,n~/.viminfo
endif

set encoding=utf-8    " Set default encoding to UTF-8
scriptencoding utf-8

set tags=./tags,tags,.git/tags

""
"" Whitespace
""

set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:☠" ,eol:¬
set backspace=indent,eol,start    " backspace through everything in insert mode

set showbreak=↪
set fillchars=diff:⣿,vert:│
set showcmd

" keep more context when scrolling off the end of a buffer
set scrolloff=3

""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

" Don't make backups at all
set nobackup
set nowritebackup
set undodir=~/.vim-tmp/undo//
set directory=~/.vim-tmp/swap//

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

set lazyredraw

" If a file is changed outside of vim, automatically reload it without asking
set autoread

set shell=bash

" Wild settings {{{

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Ignore rails temporary asset caches
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

" Ignore apiary
set wildignore+=*.apid

" }}}

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  set statusline=%f\ %m\ %r
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]
endif
" }}}

" Mappings {{{
source ~/.vim/mappings.vim

map <leader>r :w<cr>:RuboCop<cr>

" RSpec.vim mappings
nmap <silent> <leader>t :w<CR>:TestNearest<CR>
nmap <silent> <leader>T :w<CR>:TestFile<CR>

nnoremap <leader>. :BTags<cr>

" Space mappings
nmap <Space><Space> <Plug>(qf_qf_toggle)
nmap <C-n> <Plug>(qf_qf_next)
nmap <C-p> <Plug>(qf_qf_previous)


" }}}

" Others {{{

" Local vim settings
if filereadable(glob('~/.local.vim'))
  source ~/.local.vim
endif

" Project vimrc support
if filereadable('.local.vim')
  source .local.vim
endif

function! s:goyo_enter()
  silent !tmux set status off
  GitGutterDisable
  Limelight
  set scrolloff=10
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  GitGutterEnable
  Limelight!
  set scrolloff=3
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"}}}

function! QuickCommands(...)
  let cmds = [
        \ 'RuboCopFix',
        \ 'PromoteToLet',
        \ 'GitGutterUndoHunk',
        \ 'Prettier',
        \ ]

  return fzf#run({
  \ 'source':  cmds,
  \ 'sink':  '',
  \ 'options': '+m --prompt="QuickCommands> "'
  \})
endfunction
command! -nargs=0 QuickCommands call QuickCommands()

map <leader>n :QuickCommands<cr>
nmap <Leader>g <Plug>(git-messenger)

set background=dark
color solarized8_flat

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
