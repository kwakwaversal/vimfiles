setlocal expandtab shiftwidth=2 softtabstop=2
setlocal spell

noremap <buffer> <LocalLeader>p   :call VimuxRunCommand("clear; npx cucumber-js " . bufname("%"))<CR>
noremap <buffer> <LocalLeader>wip :call VimuxRunCommand("clear; npx cucumber-js --tags @wip " . bufname("%"))<CR>
