setlocal equalprg=prettier\ --stdin\ --stdin-filepath\ %\ --trailing-comma\ all\ --single-quote

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
" test('foo', () => {})    <-> test.only('foo', () => {})
" it.only('foo', () => {}) <-> it('foo', () => {})
function! s:jestTestOnly(toggle)
  " save position so we can return to it (useful when used with 'c' command)
  let l:savePos = getpos(".")

  " search backwards for the word `test` or `it`
  if (!search('^\s*\(test\|it\)', 'sbzc', 0))
    return
  endif

  if (!search('\.only(', 'zc', line(".")))
    if (a:toggle == 1)
      normal! f(i.only
    endif
    call setpos('.', l:savePos)
    return
  endif

  if (a:toggle == 1)
    normal! dt(
    call setpos('.', l:savePos)
  else
    normal! vt(
  endif
endfunction

onoremap <silent> jo :<c-u>call <sid>jestTestOnly(0)<cr>
xnoremap <silent> jo :<c-u>call <sid>jestTestOnly(0)<cr>
noremap <buffer> <LocalLeader>jo :<c-u>call <sid>jestTestOnly(1)<cr><c-o>

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
