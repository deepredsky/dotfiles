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
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-vinegar'
Plug 'christoomey/vim-system-copy'

Plug 'github/copilot.vim'
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

" Vim Ruby
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-projectionist', { 'for': ['ruby', 'eruby'] }
Plug 'deepredsky/vim-rubocop', { 'for': ['ruby', 'eruby'] }

" View helpers
Plug 'elzr/vim-json'

" Folding/TOC/GFM checkboxes for plain .md files outside vimwiki's scope
Plug 'preservim/vim-markdown', { 'for': 'markdown' }
" Fold level 6: start files unfolded (default 1 hides body text on open)
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_folding_level = 6

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

Plug 'janko-m/vim-test'

" Better search handling
Plug 'bronson/vim-visual-star-search'

" Flash the yanked region briefly (built-in package)
packadd! hlyank
let g:hlyank_duration = 1000
let g:hlyank_invisual = v:false

Plug 'logico-dev/typewriter'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'

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
Plug 'sainnhe/everforest'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/gv.vim'
Plug 'google/vim-jsonnet'

Plug 'vimwiki/vimwiki'
" Plug 'https://github.com/lervag/wiki.vim'
" let g:wiki_root = '~/wiki'

Plug 'dhruvasagar/vim-table-mode'
" Use '|' corners so tables stay valid GFM/Markdown, not just reST
let g:table_mode_corner = '|'
" Default ,t prefix made vimrc's ,t (TestNearest) wait; toggle is now ,am
let g:table_mode_map_prefix = '<Leader>a'
Plug 'reedes/vim-wordy'
Plug 'reedes/vim-litecorrect'
Plug 'reedes/vim-pencil'
" Sentence text object; native )/( breaks on "e.g."/"Mr."
Plug 'reedes/vim-textobj-sentence', { 'for': ['markdown', 'text', 'vimwiki'] }

let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md', 'template_path': '', 'custom_wiki2html': '$HOME/.bin/wiki2html.sh' }]
" Without this, vimwiki claims filetype=vimwiki for *any* .md file, not
" just files under ~/notes/ (its default "global_ext" behavior).
let g:vimwiki_global_ext = 0

Plug 'FooSoft/vim-argwrap'

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
  if exists('$TMUX')
    silent !tmux set status off
  endif
  GitGutterDisable
  set scrolloff=10
  set nocursorline
endfunction

function! s:goyo_leave()
  if exists('$TMUX')
    silent !tmux set status on
  endif
  GitGutterEnable
  set scrolloff=3
  set cursorline
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"}}}

" Open (or resume) today's note at ~/notes/daily/2026-09-26.md
function! s:NewNote() abort
  let l:dir = expand(get(get(g:vimwiki_list, 0, {}), 'path', '~/notes/')) . 'daily/'
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif
  let l:date = strftime('%Y-%m-%d')
  let l:fname = l:dir . l:date . '.md'
  let l:is_new = !filereadable(l:fname)
  execute 'edit ' . fnameescape(l:fname)
  if l:is_new
    call setline(1, '# ' . l:date)
    call append(1, '')
  endif
  normal! G
  startinsert!
endfunction
command! -nargs=0 NewNote call s:NewNote()
nnoremap <leader>zk :NewNote<CR>

" Log timestamp on a new line
nnoremap <leader>zt o<C-R>=strftime('%H:%M ')<CR>

function! s:MarkdownPreview() abort
  let l:out = '/tmp/' . expand('%:t:r') . '.html'
  let l:css = expand('~/.vim/markdown-preview.css')
  call system('pandoc --standalone --from gfm --to html5 --css=' . shellescape(l:css) . ' -o ' . shellescape(l:out) . ' -- ' . shellescape(expand('%:p')))
  let l:opener = has('mac') ? 'open' : 'xdg-open'
  execute 'silent! !' . l:opener . ' ' . shellescape(l:out, 1)
endfunction
command! -nargs=0 MarkdownPreview call s:MarkdownPreview()

function! QuickCommands(...)
  let cmds_dicts_by_ft = {
  \ 'ruby': [ 'RuboCopFix', 'TestNearest', 'TestFile' ],
  \ 'markdown': [ 'MarkdownPreview', 'TogglePencil' ],
  \ 'vimwiki': [ 'Vimwiki2HTMLBrowse', 'MarkdownPreview', 'TogglePencil' ],
  \ 'text': [ 'TogglePencil' ]
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

command! -bar -nargs=* Jump cexpr system('git jump ' . expand(<q-args>))

function! SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Resolve LSP binaries dynamically so this works on any machine/OS this
" dotfiles repo is checked out on, and skips servers that aren't installed.
let s:lspCandidates = [
      \ #{ name: 'clang', filetype: ['c', 'cpp'], bin: 'clangd', args: ['--background-index'] },
      \ #{ name: 'ruby', filetype: 'ruby', bin: 'solargraph', args: ['stdio'] },
      \ #{ name: 'go', filetype: ['go', 'gomod', 'gowork'], bin: 'gopls' },
      \ ]

let lspServers = []
for s:cand in s:lspCandidates
  let s:path = exepath(s:cand.bin)
  if !empty(s:path)
    let s:server = #{ name: s:cand.name, filetype: s:cand.filetype, path: s:path }
    if has_key(s:cand, 'args')
      let s:server.args = s:cand.args
    endif
    call add(lspServers, s:server)
  endif
endfor
unlet! s:cand s:path s:server

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
