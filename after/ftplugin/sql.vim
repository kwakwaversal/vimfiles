setlocal equalprg=sql-formatter-cli

" Takes the current buffer path and splits on expected sqitch folders. This
" has not been fully tested against edge cases where a username is called
" `test` for example. Probably will not work.
"
" @example
" Buffer path: /home/me/projects/foo/deploy/functions/bar.sql
" Expected console output: clear; pg_prove -v test/functions/bar.sql
function! s:pgtapSqitchChange()
  let l:sqitch_change_filename = split(expand('%:p'), '\v/(deploy|revert|verify|test)/')[1]
  call VimuxRunCommand("clear; pg_prove -v test/" . l:sqitch_change_filename)
endfunction

noremap <silent> <buffer> <LocalLeader>p :<c-u>call <SID>pgtapSqitchChange()<CR>

noremap <silent> <buffer> <LocalLeader>i :<c-u>call VimuxRunCommand("\\i " . bufname("%"))<CR>
noremap <silent> <buffer> <LocalLeader>q :<c-u>call VimuxSendKeys("q")<CR>
