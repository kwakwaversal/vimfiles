setlocal equalprg=prettier\ --stdin\ --stdin-filepath\ %\ --trailing-comma\ all\ --single-quote

let g:javascript_plugin_jsdoc = 1

noremap <Leader>p  :call VimuxRunCommand("clear; npx jest --watch " . bufname("%"))<CR>

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
function! s:jestTestOnly()
  " save position so we can return to it (useful when used with 'c' command)
  let l:savePos = getpos(".")

  " search backwards for the word `test` or `it`
  if (!search('^\s*\(test\|it\)', 'bzc', 0))
    return
  endif

  if (!search('\.only(', 'zc', line(".")))
    normal! f(i.only
    call setpos('.', l:savePos)
    return
  endif

  normal! dt(
  call setpos('.', l:savePos)
endfunction

onoremap <silent> jo :<c-u>call <sid>jestTestOnly()<cr>
