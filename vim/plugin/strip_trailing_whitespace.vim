function! s:StripTrailingWhitespace()
  let _save_pos=getpos(".")
  let _s=@/
  silent! %s/\s\+$//
  let @/=_s
  nohl
  unlet _s
  call setpos('.', _save_pos)
  unlet _save_pos
endfunction

nnoremap <Plug>StripTrailingWhitespace
      \ :<C-U>call <SID>StripTrailingWhitespace()<CR>
