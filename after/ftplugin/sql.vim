setlocal equalprg=sql-formatter-cli

setlocal commentstring=/*\ %s\ */

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

function! s:commentOtherBlocks()
  let view = winsaveview()
  let markers = []

  " Collect all marker line numbers
  for lnum in range(1, line('$'))
    if getline(lnum) ==# '/*****************************************************************************/'
      call add(markers, lnum)
    endif
  endfor

  if len(markers) < 2
    echo 'No blocks found'
    call winrestview(view)
    return
  endif

  " Find which block cursor is in
  let cur = line('.')
  let current = -1
  for i in range(0, len(markers)-2)
    if cur > markers[i] && cur < markers[i+1]
      let current = i
      break
    endif
  endfor
  if current == -1
    echo 'Cursor not inside a block'
    call winrestview(view)
    return
  endif

  " Comment all other blocks that contain uppercase SELECT
  for i in range(0, len(markers)-2)
    if i != current
      let start = markers[i] + 1
      let finish = markers[i+1] - 1

      " scan the block lines for SELECT
      let hasSelect = 0
      for lnum in range(start, finish)
        if match(getline(lnum), '\CSELECT') != -1
          let hasSelect = 1
          break
        endif
      endfor

      if hasSelect
        execute start . ',' . finish . 'Commentary'
      endif
    endif
  endfor

  call winrestview(view)
endfunction

noremap <buffer> <LocalLeader>jo :<c-u>call <sid>commentOtherBlocks()<CR>
