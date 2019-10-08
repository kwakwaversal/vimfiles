if exists("loaded_togglecomma")
  finish
endif

let loaded_togglecomma=1

" Toggle comma at the end of the line
function! s:toggleComma()
  " save position so we can return to it (useful when used with 'c' command)
  let l:savePos = getpos(".")

  if (!search(',$', 'zc', line(".")))
    normal! $a,
    call setpos('.', l:savePos)
    return
  endif

  normal! $x
  call setpos('.', l:savePos)
endfunction

nmap <Leader>, :call <sid>toggleComma()<cr>
