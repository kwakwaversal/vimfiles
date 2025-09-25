setlocal equalprg=prettier\ --trailing-comma\ all\ --single-quote\ --parser=babel

let g:javascript_plugin_jsdoc = 1

" Takes the current buffer path and splits on expected sqitch folders. This
" has not been fully tested against edge cases where a username is called
" `test` for example. Probably will not work.
"
" @example
" Buffer path: /home/me/projects/foo/deploy/functions/bar.sql
" Expected console output: clear; pg_prove -v test/functions/bar.sql
function! s:jestTestFile()
  let l:javascript_test_filename = split(expand('%:p'), '\v/(tests)/')[1]
  call VimuxRunCommand("clear; npx jest --watch tests/" . l:javascript_test_filename)
endfunction

noremap <buffer> <LocalLeader>p :call <SID>jestTestFile()<CR>
" noremap <buffer> <LocalLeader>p :call VimuxRunCommand("clear; npx jest --watch " . bufname("%"))<CR>

" JavaScript folding
setlocal foldlevel=99
setlocal foldlevelstart=99
setlocal foldmethod=syntax
setlocal foldcolumn=0
let javaScript_fold=1

" Toggle `only` in the closest `test(...)` or `it(...)` block.
"
" Usage:
" - Press `djo` in normal mode to toggle `.only` on the nearest test or it block.
" - Press `<leader>jo` in normal mode to toggle `.only` without moving the cursor.
"
function! s:jestTestOnly()
  " Save the current cursor position
  let l:savePos = getpos(".")

  " Search backwards for a line starting with optional whitespace followed by 'test' or 'it'
  if !search('^\s*\(test\|it\)', 'b', 0)
    echo "No test or it block found."
    return
  endif

  " Get the current line after the search
  let l:line = getline('.')

  " Determine if '.only' is present
  if l:line =~ '\.only('
    " Remove '.only' from the line
    let l:new_line = substitute(l:line, '\.only', '', '')
    call setline('.', l:new_line)
  else
    " Add '.only' after 'test' or 'it'
    let l:new_line = substitute(l:line, '\(^\s*\)\(test\|it\)', '\1\2.only', '')
    call setline('.', l:new_line)
  endif

  " Restore the original cursor position
  call setpos('.', l:savePos)
endfunction

" Operator-pending mode mapping for 'jo'
" This allows commands like 'djo' to work as expected
onoremap <silent> jo :<C-U>call <SID>jestTestOnly()<CR>

" Normal mode mapping for '<leader>jo'
" Toggles '.only' without moving the cursor
nnoremap <silent> <LocalLeader>jo :call <SID>jestTestOnly()<CR>

function! s:aroundFunction()
    " search backwards for the word function
    if (!search('function', 'bzc', 0))
        return
    endif

    let l:lineNr = line('.')

    " set visual mode
    normal! v

    " search forwards for the opening bracket
    if (!search('{', 'zc', l:lineNr + 1))
        return
    endif

    " Jump to matching closing bracket
    normal! %
endfunction

onoremap <silent> af :<c-u>call <sid>aroundFunction()<cr>o
xnoremap <silent> af :<c-u>call <sid>aroundFunction()<cr>o
