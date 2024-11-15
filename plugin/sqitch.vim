" Lifted from https://github.com/zperrault/dotfiles and tweaked slightly
let g:sqitch_cmd = 'SQITCH_TARGET=db:pg:///?service=services sqitch '

function! SqitchRerunWithTag(fn)
  let l:line = getline('.')
  execute 'quit'
  call a:fn(substitute(l:line, '  \* ', '', ''))
endfunction

function! SqitchAdd(name, requires_changes)
  system(g:sqitch_cmd . 'add ' . name . join(map(requires_changes, '--requires v:val'), ' '))
endfunction
function! SqitchDeploy(change)
  execute '20new|0r !(' . g:sqitch_cmd . 'deploy ' . a:change . ') || true'
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile

  nnoremap <silent> <buffer> <CR> :call SqitchRerunWithTag(function('SqitchDeploy'))<CR>
endfunction
function! SqitchRevert(to_change)
  execute '20new|0r !(' . g:sqitch_cmd . 'revert -y --to ' . a:to_change . ') || true'
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile

  nnoremap <silent> <buffer> <CR> :call SqitchRerunWithTag(function('SqitchRevert'))<CR>
endfunction
function! SqitchVerify(change)
  execute '20new|0r !(' . g:sqitch_cmd . 'verify --from-change ' . a:change . ' --to-change ' . a:change . ' --to-change ' . a:change . ') || true'
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile

  nnoremap <silent> <buffer> <CR> :call SqitchRerunWithTag(function('SqitchVerify'))<CR>
endfunction
function! SqitchRework(change)
  let l:result = system(g:sqitch_cmd . 'rework ' . a:change)
  execute 'edit! %'
  echo l:result
endfunction
function! GetSqitchChangeAtCurrentLine()
  let l:line = getline('.')
  let l:change = split(l:line)[0]
  return l:change
endfunction
function! GetSqitchBasePath()
  return expand('%:p:h')
endfunction
function! GetPathToSqitchChange(change, stage)
  return a:stage . '/' . a:change . '.sql'
endfunction
function! OpenAllFilesForSqitchChangeAtCurrentLine()
  let l:change = GetSqitchChangeAtCurrentLine()
  let l:base_path = GetSqitchBasePath()
  execute 'split ' . l:base_path . '/' . GetPathToSqitchChange(l:change, 'revert')
  execute 'vsplit ' . l:base_path . '/' . GetPathToSqitchChange(l:change, 'verify')
  execute 'vsplit ' . l:base_path . '/' . GetPathToSqitchChange(l:change, 'deploy')
endfunction

function! SetupSqitchFile()
  " setlocal nomodifiable

  nnoremap <silent> <buffer> <CR> :call OpenAllFilesForSqitchChangeAtCurrentLine()<CR>
  nnoremap <silent> <buffer> x    :echo "TODO: Add a new change"<CR>
  nnoremap <silent> <buffer> d    :execute 'edit ' . GetSqitchBasePath() . '/' . GetPathToSqitchChange(GetSqitchChangeAtCurrentLine(), 'deploy')<CR>
  nnoremap <silent> <buffer> r    :execute 'edit ' . GetSqitchBasePath() . '/' . GetPathToSqitchChange(GetSqitchChangeAtCurrentLine(), 'revert')<CR>
  nnoremap <silent> <buffer> v    :execute 'edit ' . GetSqitchBasePath() . '/' . GetPathToSqitchChange(GetSqitchChangeAtCurrentLine(), 'verify')<CR>
  nnoremap <silent> <buffer> t    :execute 'edit ' . GetSqitchBasePath() . '/' . GetPathToSqitchChange(GetSqitchChangeAtCurrentLine(), 'test')<CR>
  nnoremap <silent> <buffer> D    :call SqitchDeploy(GetSqitchChangeAtCurrentLine())<CR>
  nnoremap <silent> <buffer> R    :call SqitchRevert(GetSqitchChangeAtCurrentLine())<CR>
  nnoremap <silent> <buffer> V    :call SqitchVerify(GetSqitchChangeAtCurrentLine())<CR>
  nnoremap <silent> <buffer> W    :call SqitchRework(GetSqitchChangeAtCurrentLine())<CR>
endfunction

autocmd BufRead,BufNewFile sqitch.plan call SetupSqitchFile()
autocmd BufRead,BufNewFile sqitch.plan setlocal commentstring=#\ %s
