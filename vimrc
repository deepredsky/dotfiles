scriptencoding utf-8
let g:vimwiki_map_prefix = ',v'

set shell=bash
let $SHELL="bash"

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins {{{
call plug#begin('~/.vim/plugged')

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Trigger configuration.
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger='<c-e>'
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
Plug 'christoomey/vim-system-copy'

Plug 'github/copilot.vim'

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

Plug 'yegappan/lsp'

command! -bang -nargs=* -complete=file Ag           call ack#Ack('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file AgFromSearch call ack#AckFromSearch('grep<bang>', <q-args>)

Plug 'rhysd/committia.vim'

Plug 'elixir-lang/vim-elixir'
Plug 'fatih/vim-go'

Plug 'janko-m/vim-test'

" Better search handling
Plug 'bronson/vim-visual-star-search'

Plug 'walm/jshint.vim'
Plug 'logico-dev/typewriter'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'

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

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Haskell
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'mpickering/hlint-refactor-vim', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }

Plug 'vmchale/dhall-vim'

" Improved UI
Plug 'flazz/vim-colorschemes'
Plug 'lifepillar/vim-solarized8'
Plug 'sainnhe/everforest'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/gv.vim'
Plug 'google/vim-jsonnet'

Plug 'vimwiki/vimwiki'
" Plug 'https://github.com/lervag/wiki.vim'
" let g:wiki_root = '~/wiki'

let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md', 'template_path': '', 'custom_wiki2html': '$HOME/.bin/wiki2html.sh' }]

Plug 'FooSoft/vim-argwrap'
Plug 'tyrannicaltoucan/vim-quantum'

Plug 'ElmCast/elm-vim'
let g:elm_setup_keybindings = 0

Plug 'romainl/vim-qf'
Plug 'romainl/vim-devdocs'

Plug 'dag/vim-fish'
Plug 'markonm/traces.vim'

call plug#end()
" }}}

source ~/.vim/basic-settings.vim

source ~/.vim/mappings.vim

map <leader>r :update<cr>:RuboCop<cr>

nmap <silent> <leader>t :update<CR>:TestNearest<CR>
nmap <silent> <leader>T :update<CR>:TestFile<CR>

nnoremap <leader>. :BTags<cr>

" }}}

" Others {{{

function! s:goyo_enter()
  silent !tmux set status off
  GitGutterDisable
  set scrolloff=10
  set nocursorline
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  GitGutterEnable
  set scrolloff=3
  set cursorline
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"}}}

function! QuickCommands(...)
  let cmds_dicts_by_ft = {
  \ 'ruby': [ 'RuboCopFix', 'TestNearest', 'TestFile' ],
  \ 'javascript': [ 'Prettier' ],
  \ 'markdown': [ 'Vimwiki2HTMLBrowse' ],
  \ 'vimwiki': [ 'Vimwiki2HTMLBrowse' ]
  \}

  let global_cmds = [
        \ 'GitGutterUndoHunk',
        \ ]

  let cmds = global_cmds + get(cmds_dicts_by_ft, &ft, [])

  return fzf#run({
  \ 'source':  cmds,
  \ 'sink':  '',
  \ 'options': '+m --prompt="QuickCommands> "'
  \})
endfunction
command! -nargs=0 QuickCommands call QuickCommands()

map <leader>n :QuickCommands<cr>
map <leader>gb :G blame<cr>
map <leader>gc :G<cr>
map <leader>gB :GBrowse<cr>
vmap <leader>gB :GBrowse<cr>
map <leader>gj :Jump diff head<cr>
map <leader>gJ :Jump diff head^<cr>

nmap <leader>v- <Plug>VimwikiRemoveHeaderLevel

command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))

if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) slash#blink(2, 50)
endif

function! SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

let lspServers = [#{
	\	  name: 'clang',
	\	  filetype: ['c', 'cpp'],
	\	  path: '/usr/bin/clangd',
	\	  args: ['--background-index']
	\ },
  \ #{
	\	  name: 'ruby',
	\	  filetype: 'ruby',
	\	  path: '/Users/rajesh.sharma/.rbenv/shims/ruby-lsp'
	\ }
\]

function! s:on_lsp_buffer_enabled()
  setlocal omnifunc=g:LspOmniFunc
  setlocal signcolumn=yes

  nnoremap <buffer> gd <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> <C-W>gd <Cmd>topleft LspGotoDefinition<CR>
  nmap <buffer> [g <Cmd>LspDiag prev<CR>
  nmap <buffer> ]g <Cmd>LspDiag next<CR>
  nmap <buffer> ,k <Cmd>LspHover<CR>
  nmap <buffer> <leader>ca <Cmd>LspCodeAction<CR>
  nnoremap <buffer> <leader>cl <Cmd>LspCodeLens<CR>
endfunction

autocmd User LspSetup call LspAddServer(lspServers)
autocmd User LspAttached call s:on_lsp_buffer_enabled()

let lspOpts = #{
      \ autoHighlightDiags: v:true,
      \ showDiagOnStatusLine: v:true,
      \ showInlayHints: v:true
      \}

autocmd User LspSetup call LspOptionsSet(lspOpts)
