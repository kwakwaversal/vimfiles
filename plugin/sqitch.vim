" Lifted from https://github.com/zperrault/dotfiles and tweaked quite a bit.
let g:sqitch_cmd = 'SQITCH_TARGET=db:pg:///?service=services sqitch '

" Run a Sqitch command and display output.
"
" Uses the Vimux plugin if available, else falls back to a Vim buffer.
function! RunAndDisplaySqitchCommand(cmd, rerun_func)
  let l:full_cmd = g:sqitch_cmd . a:cmd

  " Start with the current file's directory
  let l:sqitch_root = expand('%:p:h')

  " Walk up the directory tree to find sqitch.plan
  while l:sqitch_root !=# '/' && !filereadable(l:sqitch_root . '/sqitch.plan')
    let l:sqitch_root = fnamemodify(l:sqitch_root, ':h')
  endwhile

  " Validate that sqitch.plan was found
  if !filereadable(l:sqitch_root . '/sqitch.plan')
    echoerr 'sqitch.plan not found in any parent directory'
    return
  endif

  if exists('*VimuxRunCommand')
    " Run asynchronously in tmux pane via Vimux
    call VimuxRunCommand("cd " . fnameescape(l:sqitch_root) . "; clear; " . l:full_cmd)
  else
    " Run synchronously and display in a new Vim buffer
    let l:original_cwd = getcwd()
    execute 'cd ' . fnameescape(l:sqitch_root)
    let l:output = systemlist(l:full_cmd)
    execute 'cd ' . fnameescape(l:original_cwd)
    execute '20new'
    call setline(1, l:output)
    " Set up temporary buffer
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    " Map <CR> to rerun the command
    nnoremap <silent> <buffer> <CR> :call SqitchRerunWithTag(a:rerun_func)<CR>
    if v:shell_error
      echoerr 'Command failed: See output buffer for details'
    endif
  endif
endfunction

function! SqitchDeploy(change)
  call RunAndDisplaySqitchCommand('deploy ' . a:change, function('SqitchDeploy'))
endfunction

function! SqitchRevert(to_change)
  call RunAndDisplaySqitchCommand('revert -y --to ' . a:to_change, function('SqitchRevert'))
endfunction

function! SqitchVerify(change)
  call RunAndDisplaySqitchCommand('verify --from-change ' . a:change . ' --to-change ' . a:change, function('SqitchVerify'))
endfunction

function! SqitchRework(change)
  if empty(a:change)
    echoerr 'No change name provided'
    return
  endif

  let l:cmd = 'sqitch rework ' . a:change . ' -n '
  if exists('*VimuxSendText')
    " Clear tmux pane and send command
    call VimuxRunCommand("clear")
    call VimuxSendText(l:cmd)
  else
    " Echo command if Vimux is unavailable
    echo 'Would send to terminal: ' . l:cmd
  endif
endfunction

function! GetSqitchChangeAtCurrentLine()
  let l:line = trim(getline('.'))
  let l:line = substitute(l:line, '^\*\s*', '', '')
  if empty(l:line) || l:line =~ '^#'
    echoerr 'No valid change name under cursor'
    return ''
  endif
  let l:words = split(l:line)
  if empty(l:words)
    echoerr 'No valid change name under cursor'
    return ''
  endif
  let l:change = l:words[0]
  if l:change =~ '^\[.*\]$' || l:change =~ '^@'
    echoerr 'Invalid change name: ' . l:change
    return ''
  endif
  return l:change
endfunction

function! GetSqitchBasePath()
  return expand('%:p:h')
endfunction

function! GetPathToSqitchChange(change, stage)
  return a:stage . '/' . a:change . '.sql'
endfunction

function! OpenSqitchChangeFile(stage)
  let l:change = GetSqitchChangeAtCurrentLine()
  if empty(l:change)
    " Do not open a buffer if change is invalid or empty
    return
  endif
  let l:path = GetSqitchBasePath() . '/' . GetPathToSqitchChange(l:change, a:stage)
  if !filereadable(l:path)
    echoerr 'File does not exist: ' . l:path
    return
  endif
  execute 'edit ' . fnameescape(l:path)
endfunction

function! OpenAllFilesForSqitchChangeAtCurrentLine()
  let l:change = GetSqitchChangeAtCurrentLine()
  let l:base_path = GetSqitchBasePath()
  execute 'split ' . l:base_path . '/' . GetPathToSqitchChange(l:change, 'revert')
  execute 'vsplit ' . l:base_path . '/' . GetPathToSqitchChange(l:change, 'verify')
  execute 'vsplit ' . l:base_path . '/' . GetPathToSqitchChange(l:change, 'deploy')
endfunction

function! SetupSqitchFile()
  nnoremap <silent> <buffer> <CR> :call OpenAllFilesForSqitchChangeAtCurrentLine()<CR>
  nnoremap <silent> <buffer> x    :echo "TODO: Add a new change"<CR>

  nnoremap <silent> <buffer> d    :call OpenSqitchChangeFile('deploy')<CR>
  nnoremap <silent> <buffer> r    :call OpenSqitchChangeFile('revert')<CR>
  nnoremap <silent> <buffer> v    :call OpenSqitchChangeFile('verify')<CR>
  nnoremap <silent> <buffer> t    :call OpenSqitchChangeFile('test')<CR>

  nnoremap <silent> <buffer> D    :call SqitchDeploy(GetSqitchChangeAtCurrentLine())<CR>
  nnoremap <silent> <buffer> R    :call SqitchRevert(GetSqitchChangeAtCurrentLine())<CR>
  nnoremap <silent> <buffer> V    :call SqitchVerify(GetSqitchChangeAtCurrentLine())<CR>
  nnoremap <silent> <buffer> W    :call SqitchRework(GetSqitchChangeAtCurrentLine())<CR>
endfunction

autocmd BufRead,BufNewFile sqitch.plan call SetupSqitchFile()
autocmd BufRead,BufNewFile sqitch.plan setlocal commentstring=#\ %s
