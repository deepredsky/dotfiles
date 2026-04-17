let mapleader = ","

set relativenumber    " Show relative line numbers
set number            " Show line numbers
set ruler             " Show line and column number
set colorcolumn=80
set wildmenu
set wildoptions+=pum
set cursorline
let g:fzf_layout = { 'down': '50%' }
let g:fzf_preview_window = []

set termguicolors

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
set backupdir=~/.vim-tmp/backup//
set undodir=~/.vim-tmp/undo//
set directory=~/.vim-tmp/swap//

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
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

source ~/.vim/statusline.vim

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  autocmd FileType vimwiki setlocal spell textwidth=79 formatoptions=tcroqn2
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd FileType asciidoc setlocal ts=2 sw=2 sts=2 et

  autocmd BufRead *.mkd setlocal ai tw=79 spell formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown setlocal ai spell formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.md setlocal ai spell formatoptions=tcroqn2 comments=n:&gt;

  " Don't spellcheck urls
  au BufReadPost * syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell
  au BufReadPost * syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s\|:+ contains=@NoSpell

  " indent slim two spaces, not four
  autocmd! FileType *.slim set sw=2 sts=2 et
augroup END

set background=dark
let g:everforest_background = 'hard'
let g:everforest_transparent_background = 2
color everforest

" Redirect the output of a Vim or external command into a scratch buffer
function! Redir(cmd) abort
    let output = execute(a:cmd)
    tabnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 Redir silent call Redir(<f-args>)
"
" Redirect the output of a Vim or external command to a file
function! WRedir(cmd) abort
    let output = execute(a:cmd)
    let fname = 'output.txt'
    call writefile(split(output, "\n"), fname, "a")
endfunction
command! -nargs=1 WRedir silent call WRedir(<f-args>)

let g:vimwiki_conceal_pre = 0

" Local vim settings
if filereadable(glob('~/.local.vim'))
  source ~/.local.vim
endif

" Project vimrc support
if filereadable('.local.vim')
  source .local.vim
endif

function! UpdateBackground()
  if filereadable('/tmp/light-theme')
    set background=light
  else
    set background=dark
  endif
endfunction

call UpdateBackground()
