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

" Autocompletion helpers

Plug 'lifepillar/vim-mucomplete'

  "{{{ Config 'lifepillar/vim-mucomplete'
  set completeopt+=menuone,noselect
  let g:mucomplete#enable_auto_at_startup = 1
  let g:mucomplete#chains = { 'default': [ 'c-p' ], 'rust': ['omni'] }

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

Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'

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

Plug '/opt/homebrew/opt/fzf' | Plug 'junegunn/fzf.vim'

Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Haskell
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'enomsg/vim-haskellConcealPlus', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'mpickering/hlint-refactor-vim', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }

" Improved UI
Plug 'flazz/vim-colorschemes'
Plug 'lifepillar/vim-solarized8'
Plug 'sainnhe/everforest'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/gv.vim'

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

Plug 'deepredsky/vim-jira'
Plug 'dag/vim-fish'
Plug 'markonm/traces.vim'

call plug#end()
" }}}

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
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

nmap <leader>v- <Plug>VimwikiRemoveHeaderLevel

command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))

if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) slash#blink(2, 50)
endif

let g:lsp_settings_enable_suggestions = 0
let g:lsp_inlay_hints_enabled = 1
let g:lsp_inlay_hints_mode = {
      \ 'normal': ['always', 'always'],
      \ 'insert': ['always', 'always'],
      \ }

hi! link lspInlayHintsType LineNr
hi! link lspInlayHintsParameter LineNr
hi! link LspErrorHighlight Comment

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  " nmap <buffer> gs <plug>(lsp-document-symbol-search)
  " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nmap <buffer> ca <Plug>(lsp-code-action-float)

  nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
  vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
  nnoremap <buffer> <leader>cl :LspCodeLens<CR>
  autocmd! BufWritePre *.rs call execute('LspDocumentFormatSync')
endfunction

augroup configure_lsp
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

imap <F23> <plug>(MUcompleteFwd)
imap <F24> <plug>(MUcompleteBwd)

" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
