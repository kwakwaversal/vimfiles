setlocal equalprg=perltidy

noremap <Leader>p  :call VimuxRunCommand("clear; prove -lv " . bufname("%"))<CR>
noremap <Leader>pd :call VimuxRunCommand("clear; perldoc " . bufname("%"))<CR>
noremap <Leader>pry  ouse Pry; pry();<ESC><CR>
