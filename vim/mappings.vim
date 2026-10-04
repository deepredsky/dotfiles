nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap Y  y$

" Keep the selection after indenting so it can be repeated
xnoremap < <gv
xnoremap > >gv

" Repeat the last :s with its flags (plain & drops them)
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Run a macro on each selected line: select, then @q
xnoremap @ :<C-u>execute ":'<,'>normal @" . nr2char(getchar())<CR>
" Terminals send <Tab> as <C-i>, so this shadows jumplist-forward
nnoremap <Tab> za

nmap <silent> <F5> <Plug>StripTrailingWhitespace

" Native Wayland clipboard is flaky; setsid keeps wl-copy serving while Vim is suspended
if exists('$WAYLAND_DISPLAY') && executable('wl-copy')
  xnoremap <silent> <Leader>c y:call system('setsid -f wl-copy', @")<CR>
  let g:system_copy#copy_command = 'setsid -f wl-copy'
else
  xnoremap <Leader>c "+y
endif
nnoremap <leader>p :put +<CR>
" Counts use real lines so they match relativenumber
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
nnoremap <leader>cd :lcd %:h<cr>

noremap <Leader><Leader> :
nnoremap <Leader>w :update<CR>

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
nnoremap <leader>/ :RG<CR>
nnoremap <leader>* :Rg <C-R><C-W><CR>
nnoremap <leader>o :History<CR>

" Shortcut for expanding to the directory of the currently displayed file
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Shortcut for expanding to full filename of the currently displayed file
cnoremap $$ <C-R>=expand('%')<CR>

nmap <Leader><Space> <Plug>VimwikiToggleListItem
vmap <Leader><Space> <Plug>VimwikiToggleListItem
" Claiming this Plug target stops vimwiki from mapping '-', which vinegar uses
nmap <leader>v- <Plug>VimwikiRemoveHeaderLevel

nnoremap <leader>G :Goyo<CR>
nnoremap <leader>cw :Wordy<CR>
nnoremap <leader>ss :setlocal spell!<CR>
" Fix the previous misspelling with its first suggestion, keeping the cursor
function! s:FixLastSpelling() abort
  let l:view = winsaveview()
  normal! [s1z=
  call winrestview(l:view)
endfunction
nnoremap <silent> <leader>sf :call <SID>FixLastSpelling()<CR>

" Space mappings
nmap <Space><Space> <Plug>(qf_qf_toggle)
nmap <C-n> <Plug>(qf_qf_next)
nmap <C-p> <Plug>(qf_qf_previous)
