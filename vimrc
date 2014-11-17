set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Vim Ruby
Plugin 'vim-ruby/vim-ruby'

" Vim Rails
Plugin 'tpope/vim-rails'

" Haml support
Plugin 'tpope/vim-haml'

" Vim Matchit
Plugin 'tmhedberg/matchit'

" Vim Tabular
Plugin 'godlygeek/tabular'

" Vim Endwise
Plugin 'tpope/vim-endwise'

" Vim Fugitive
Plugin 'tpope/vim-fugitive'

" Vim Rbenv
Plugin 'tpope/vim-rbenv'

" Coffeescript Support
Plugin 'kchmck/vim-coffee-script'

" You complete me
Plugin 'Valloric/YouCompleteMe'

" Ag helper
Plugin 'rking/ag.vim'

" Ag helper
Plugin 'regedarek/ZoomWin'

" Rabl Syntax
Plugin 'yaymukund/vim-rabl'

" JSON Syntax
Plugin 'elzr/vim-json'

" ctrl+p
Plugin 'kien/ctrlp.vim'

" indent guides
Plugin 'nathanaelkane/vim-indent-guides'

" nice themes compatibility
Plugin 'godlygeek/csapprox'

" tagbar
Plugin 'majutsushi/tagbar'

Plugin 'bling/vim-airline'

Plugin 'slim-template/vim-slim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

""
"" Basic Setup
""

let mapleader = ","
set t_Co=256

colorscheme grb256
"color ir_black-256
"color beauty256
"colorscheme pyte
"colorscheme oceanlight
"

"let g:solarized_termcolors=256
"colorscheme solarized
set background=dark

set nocompatible      " Use vim, no vi defaults
set relativenumber            " Show line numbers
set number            " Show line numbers
set ruler             " Show line and column number
syntax enable         " Turn on syntax highlighting allowing local overrides
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set viminfo='10,\"100,:20,%,n~/.viminfo

set encoding=utf-8    " Set default encoding to UTF-8

""
"" Whitespace
""

set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode


" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the left of the screen

""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

set backup
set backupdir=~/.vim/backup/
set directory=~/.vim/swap/

""
"" Wild settings
""

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

" Sane Ignore For ctrlp
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp\|vendor$',
  \ 'file': '\.exe$\|\.so$\|\.dat$'
  \ }

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Start the status line
  set statusline=%f\ %m\ %r
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]
endif

" Create the directory containing the file in the buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

nmap <leader>ew :e <C-R>=expand('%:h').'/'<cr>

map <leader>t :w<cr>:call RunCurrentLineInTest()<CR>


" tagbar mapping
nnoremap <silent> <Leader>b :TagbarToggle<CR>

" ctrl+p tags mapping
nnoremap <leader>. :CtrlPTag<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Test-running stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RunCurrentTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()

    if match(expand('%'), '\.feature$') != -1
      call SetTestRunner("!bin/cucumber")
      exec g:bjo_test_runner g:bjo_test_file
    elseif match(expand('%'), '_spec\.rb$') != -1
      call SetTestRunner("!be rspec")
      exec g:bjo_test_runner g:bjo_test_file
    else
      call SetTestRunner("!ruby -Itest")
      exec g:bjo_test_runner g:bjo_test_file
    endif
  else
    exec g:bjo_test_runner g:bjo_test_file
  endif
endfunction

function! SetTestRunner(runner)
  let g:bjo_test_runner=a:runner
endfunction

function! RunCurrentLineInTest()
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFileWithLine()
  end

  exec "!spring rspec " g:bjo_test_file . ":" . g:bjo_test_file_line
endfunction

function! SetTestFile()
  let g:bjo_test_file=@%
endfunction

function! SetTestFileWithLine()
  let g:bjo_test_file=@%
  let g:bjo_test_file_line=line(".")
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
