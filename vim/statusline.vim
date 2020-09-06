highlight default link User1 TabLine
highlight default link User4 PmenuSel

set laststatus=2

function! s:fileinfo() abort
  let l:statuslinetext = ' %F'
  let l:statuslinetext .= ' %m'
  let l:statuslinetext .= '%='
  return l:statuslinetext
endfunction

function! s:bufinfo() abort
  let l:statuslinetext = ' %4(%p%%%) '
  let l:statuslinetext .= '%5(%l:%c%) '
  return l:statuslinetext
endfunction

function! Statusline_active() abort
  let l:statuslinetext = s:fileinfo()
  let l:statuslinetext .= '%4* %Y %*'
  let l:statuslinetext .= '%1*'
  let l:statuslinetext .= s:bufinfo()
  let l:statuslinetext .= '%*'
  return l:statuslinetext
endfunction

function! Statusline_inactive() abort
  let l:statuslinetext = s:fileinfo()
  let l:statuslinetext .= ' %Y '
  let l:statuslinetext .= s:bufinfo()
  return l:statuslinetext
endfunction

set statusline=%!Statusline_active()
augroup vimrc_statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!Statusline_active()
  autocmd WinLeave * setlocal statusline=%!Statusline_inactive()
augroup END

