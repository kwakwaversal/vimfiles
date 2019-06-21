setlocal expandtab shiftwidth=2 softtabstop=2

noremap <Leader>p   :call VimuxRunCommand("clear; npx cucumber-js " . bufname("%"))<CR>
noremap <Leader>wip :call VimuxRunCommand("clear; npx cucumber-js --tags @wip " . bufname("%"))<CR>
