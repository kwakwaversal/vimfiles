setlocal equalprg=prettier\ --stdin\ --stdin-filepath\ %\ --trailing-comma\ all\ --single-quote

let g:javascript_plugin_jsdoc = 1

noremap <Leader>p  :call VimuxRunCommand("clear; npx jest --watch " . bufname("%"))<CR>
