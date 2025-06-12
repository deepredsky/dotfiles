nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap Y  y$

nmap <silent> <F5> <Plug>StripTrailingWhitespace

vnoremap <Leader>c "+y
nnoremap <leader>p <Plug>SystemPasteLine
nnoremap j gj
nnoremap k gk
nmap cd :lcd %:h<cr>

map <Leader><Leader> :
map <Leader>w :update<CR>

" Do not use <Ctrl-c> to break out to normal mode
" Use C-Space to Esc out of any mode
nnoremap <C-Space> <Esc>:noh<CR>
vnoremap <C-Space> <Esc>gV
onoremap <C-Space> <Esc>
cnoremap <C-Space> <C-c>
inoremap <C-Space> <Esc>`^
" Terminal sees <C-@> as <C-space>
nnoremap <C-@> <Esc>:noh<CR>
vnoremap <C-@> <Esc>gV
onoremap <C-@> <Esc>
cnoremap <C-@> <C-c>
inoremap <C-@> <Esc>`^

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
vnoremap K "ay:Ag "<C-r>a"<CR>

" Create the directory containing the file in the buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>
nmap <leader>ew :e <C-R>=expand('%:h').'/'<cr>

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<cr>

" Shortcut for expanding to the directory of the currently displayed file
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Shortcut for expanding to full filename of the currently displayed file
cnoremap $$ <C-R>=expand('%')<CR>

nmap <Leader><Space> <Plug>VimwikiToggleListItem
vmap <Leader><Space> <Plug>VimwikiToggleListItem
nmap <F23> <Plug>VimwikiRemoveHeaderLevel

" Space mappings
nmap <Space><Space> <Plug>(qf_qf_toggle)
nmap <C-n> <Plug>(qf_qf_next)
nmap <C-p> <Plug>(qf_qf_previous)

imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" fix broken newrw gx
nnoremap <silent> gx :execute 'silent! !open ' . shellescape(expand('<cWORD>'), 1)<cr>
