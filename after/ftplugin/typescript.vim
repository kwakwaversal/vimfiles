setlocal equalprg=prettier\ --trailing-comma\ all\ --single-quote\ --parser=babel-ts

" Executes the current test file using Jest with a dynamic configuration.
"
" This function retrieves the absolute path of the current buffer (test file),
" identifies the corresponding package directory within the 'packages' folder,
" and constructs a Jest command to run the test file with the appropriate
" configuration file. The Jest configuration path is dynamically determined
" based on the package in which the test file is located.
"
" Example:
" For the buffer path:
"   /home/foo/apps/doc-parser/packages/api/src/service/app.test.ts
" The executed command will be:
"   clear; npx jest --watch /home/foo/apps/doc-parser/packages/api/src/service/app.test.ts -c packages/api/jest.config.ts
"
function! s:jestTestFile()
  " Get the absolute path of the current buffer
  let l:absolute_path = expand('%:p')

  " Extract the package directory from the absolute path
  " This regex looks for '/packages/<package-name>/' in the path
  let l:package_match = matchlist(l:absolute_path, '\v/(packages/[^/]+)/')

  " Check if the package directory was found
  if len(l:package_match) < 2
    echoerr "Error: Could not determine the package directory from the file path."
    return
  endif

  " The package directory (e.g., '/packages/api')
  let l:package_path = l:package_match[1]

  " Define the Jest configuration path based on the package directory
  let l:jest_config = l:package_path . '/jest.config.ts'

  " Construct the Jest command
  let l:jest_command = 'clear; npx jest --watch ' . shellescape(l:absolute_path) . ' -c ' . shellescape(l:jest_config)

  " Run the Jest command using Vimux
  call VimuxRunCommand(l:jest_command)
endfunction

noremap <buffer> <LocalLeader>p :call <SID>jestTestFile()<CR>

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
