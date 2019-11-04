if exists("loaded_togglechar")
  finish
endif

let loaded_togglechar=1

" Toggle any char at the end of the line
function! s:toggleChar(char)
  " save position so we can return to it (useful when used with 'c' command)
  let l:savePos = getpos(".")
  let l:char = a:char

  if (l:char == '.')
    let l:char = '\.'
  endif

  if (!search(l:char . '$', 'zc', line(".")))
    execute "normal! $a" . a:char
    call setpos('.', l:savePos)
    return
  endif

  normal! $x
  call setpos('.', l:savePos)
endfunction

nmap <silent> <Leader>, :call <sid>toggleChar(',')<cr>
nmap <silent> <Leader>; :call <sid>toggleChar(';')<cr>
nmap <silent> <Leader>. :call <sid>toggleChar('.')<cr>
