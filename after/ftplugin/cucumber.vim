setlocal expandtab shiftwidth=2 softtabstop=2
setlocal spell

noremap <buffer> <LocalLeader>p   :call VimuxRunCommand("clear; npx cucumber-js " . bufname("%"))<CR>
noremap <buffer> <LocalLeader>wip :call VimuxRunCommand("clear; npx cucumber-js --tags @wip " . bufname("%"))<CR>

" Surround any {string} cucumber parameter types to create cucumber string
" expression with single quotes.
"
" @see https://cucumber.io/docs/cucumber/cucumber-expressions/#parameter-types
" @example
" s:makeUltiSnipsPlaceholder('string', [])
" // expected output: "${1:string}"
" s:makeUltiSnipsPlaceholder('int', [])
" // expected output: ${1:int}
function! s:makeUltiSnipsCucumberPlaceholder(paramType, paramList)
  call add(a:paramList, a:paramType)
  if (a:paramType == 'string')
    " Surrounds this `string` parameter type with 'single quotes'
    return "''${" . len(a:paramList) . ":" . a:paramType . "}''"
  else
    return "${" . len(a:paramList) . ":" . a:paramType . "}"
  endif
endfunction

" Custom function that takes a quickfix line and returns a cucumber expression
" based on it.
"
" @see https://gist.github.com/waldson/18d4412975bf39ac64d70aadb5aeac9a
" @example
" s:quickfixLineToSnippet("features/step_definitions/foo_steps.js:236:0:Given('{string} is foo', async function(contact) {")
" // expected output: "'${1:string}' is foo"
" s:quickfixLineToSnippet("features/step_definitions/bar_steps.js:236:0:Given('I have {int} bananas', async function(contact) {")
" // expected output: "I have ${1:int} bananas"
function! s:quickfixLineToSnippet(line)
  " Get everything between the apostrophes (currently will not work for
  " regex step definitions).
  let l:step = matchstr(a:line, '\v[^\(]+\(''\zs([^'']+)')

  " Hack to track ultisnips `$1` placeholders for tabbing
  let l:paramList = []

  " Create the anonymous snippet by replacing {.*?} with ultisnips placeholder
  let l:snippet = substitute(l:step, '{\([a-zA-Z]\+\)}', '\=s:makeUltiSnipsCucumberPlaceholder(submatch(1), l:paramList)', 'g')

  return l:snippet
endfunction

function! s:lineToSnippet(line)
  let l:snippet = s:quickfixLineToSnippet(a:line)

  " execute "normal! o" . l:snippet . "\<cr>"
  execute "normal! O\<C-r>=UltiSnips#Anon('$0" . l:snippet . "')\<cr>"
endfunction

function! s:fzfCucumberSteps()
  call fzf#run({
        \ 'source': "ag -G '_steps.js$' --vimgrep '^\\s+(Given|When|Then)'",
        \ 'sink': function('s:lineToSnippet'),
        \ 'down': '30%'
  \})
endfunction

command! -buffer CucumberSteps call <sid>fzfCucumberSteps()
inoremap <buffer> <C-l> <esc>:CucumberSteps<CR>
