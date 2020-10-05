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
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-vinegar'

" Vim Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'tpope/vim-rbenv'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-projectionist'
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
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/gv.vim'

Plug 'vimwiki/vimwiki'

let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md', 'template_path': '', 'custom_wiki2html': '$HOME/.bin/wiki2html.sh' }]

Plug 'FooSoft/vim-argwrap'
Plug 'tyrannicaltoucan/vim-quantum'

Plug 'ElmCast/elm-vim'
let g:elm_setup_keybindings = 0

Plug 'romainl/vim-qf'

Plug 'deepredsky/vim-pivotal'
Plug 'deepredsky/vim-jira'
Plug 'dag/vim-fish'

call plug#end()
" }}}

source ~/.vim/basic-settings.vim

source ~/.vim/mappings.vim

map <leader>r :w<cr>:RuboCop<cr>

" RSpec.vim mappings
nmap <silent> <leader>t :w<CR>:TestNearest<CR>
nmap <silent> <leader>T :w<CR>:TestFile<CR>

nnoremap <leader>. :BTags<cr>

" }}}

" Others {{{

function! s:goyo_enter()
  silent !tmux set status off
  GitGutterDisable
  Limelight
  set scrolloff=10
  set nocursorline
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  GitGutterEnable
  Limelight!
  set scrolloff=3
  set cursorline
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

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.5 } }

command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))

if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) slash#blink(2, 50)
endif

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
