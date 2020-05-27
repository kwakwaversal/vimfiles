setlocal equalprg=perltidy

" Takes the current buffer path and splits on expected folders. This has not
" been fully tested against edge cases where a username is called `test` for
" example. Probably will not work.
"
" @example
" Buffer path: /home/me/projects/foo/t/test.t
" Expected console output: clear; prove -lv t/test.t
function! s:proveTestFile()
  let l:javascript_test_filename = split(expand('%:p'), '\v/(t)/')[1]
  call VimuxRunCommand("clear; prove -lv t/" . l:javascript_test_filename)
endfunction

noremap <buffer> <LocalLeader>p  :call <SID>proveTestFile()<CR>
noremap <buffer> <LocalLeader>pd :call VimuxRunCommand("clear; perldoc " . bufname("%"))<CR>
noremap <buffer> <LocalLeader>pry  ouse Pry; pry();<ESC><CR>

