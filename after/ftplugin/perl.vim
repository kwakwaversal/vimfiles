setlocal equalprg=perltidy

noremap <buffer> <LocalLeader>p  :call VimuxRunCommand("clear; prove -lv " . bufname("%"))<CR>
noremap <buffer> <LocalLeader>pd :call VimuxRunCommand("clear; perldoc " . bufname("%"))<CR>
noremap <buffer> <LocalLeader>pry  ouse Pry; pry();<ESC><CR>
