nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Function keys

nnoremap <silent> <F5> :call StripTrailingWhitespace()<cr>

function! StripTrailingWhitespace()
  let _save_pos=getpos(".")
  let _s=@/
  silent! %s/\s\+$//
  let @/=_s
  nohl
  unlet _s
  call setpos('.', _save_pos)
  unlet _save_pos
endfunction

vnoremap <Leader>c "+y
nnoremap <leader>p :r!pbpaste<cr>

nnoremap j gj
nnoremap k gk

map <Leader><Leader> :
map <Leader>w :w<CR>

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

nnoremap <silent> <leader>f :Files<CR>
nnoremap <leader>b :Buffers<cr>

" Shortcut for expanding to the directory of the currently displayed file
cnoremap %% <C-R>=expand('%:h').'/'<CR>

" Shortcut for expanding to full filename of the currently displayed file
cnoremap $$ <C-R>=expand('%')<CR>

