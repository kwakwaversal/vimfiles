" netrw_tree.vim - keep netrw behaving like a side bar

if exists('g:loaded_netrw_tree_sidebar')
  finish
endif
let g:loaded_netrw_tree_sidebar = 1

let g:netrw_altv=1              " place edit splits to the right of the tree
let g:netrw_banner=0            " disable the banner
let g:netrw_browse_split=4      " keep edits opening in the previous window
let g:netrw_liststyle=3         " enable tree view
let g:netrw_winsize = 25        " start at roughly 25% width
let g:netrw_wiw = 30            " enforce a minimum width for the tree
let g:netrw_keepdir=0           " sync :pwd with the highlighted directory
if !exists('g:netrw_tree_width')
  let g:netrw_tree_width = 30
endif
if !exists('g:netrw_tree_max_ratio')
  let g:netrw_tree_max_ratio = 0.45
endif
if !exists('g:netrw_tree_other_min')
  let g:netrw_tree_other_min = 40
endif

function! ToggleNetrwTree() abort
  if exists('t:netrw_winid') && win_gotoid(t:netrw_winid)
    close
    unlet t:netrw_winid
    if exists('t:netrw_prevwinid') && win_id2win(t:netrw_prevwinid)
      call win_gotoid(t:netrw_prevwinid)
    endif
  else
    let t:netrw_prevwinid = win_getid()
    Lexplore
    let t:netrw_bufnr = bufnr('%')
    let t:netrw_winid = win_getid()
    wincmd H
    call s:ResizeNetrwTree()
    call win_gotoid(t:netrw_winid)
  endif
endfunction

function! s:NetrwOpenKeepingFocus() abort
  let l:tree_win = win_getid()
  let l:tree_view = winsaveview()
  execute "keepalt keepjumps normal \<Plug>NetrwLocalBrowseCheck"
  if &filetype !=# 'netrw'
    let t:netrw_prevwinid = win_getid()
    call win_gotoid(l:tree_win)
    call winrestview(l:tree_view)
    let t:netrw_bufnr = bufnr('%')
    call s:ResizeNetrwTree()
  endif
endfunction

function! s:ResizeNetrwTree() abort
  if !exists('t:netrw_winid') || win_id2win(t:netrw_winid) == 0
    return
  endif
  let l:minwidth = get(g:, 'netrw_tree_width', 30)
  let l:maxwidth = max([l:minwidth, float2nr(&columns * get(g:, 'netrw_tree_max_ratio', 0.45))])
  if exists('t:netrw_bufnr') && bufexists(t:netrw_bufnr)
    let l:lines = getbufline(t:netrw_bufnr, 1, '$')
    if !empty(l:lines)
      let l:longest = max(map(copy(l:lines), 'strlen(v:val)')) + 2
    else
      let l:longest = l:minwidth
    endif
  else
    let l:longest = l:minwidth
  endif
  let l:maxallowed = max([l:minwidth, &columns - get(g:, 'netrw_tree_other_min', 40)])
  let l:target = max([l:minwidth, min([l:longest, l:maxwidth, l:maxallowed])])
  call win_execute(t:netrw_winid, 'vertical resize ' . l:target)
endfunction

function! s:SetupNetrwMappings() abort
  nnoremap <silent><buffer> <CR> :call <SID>NetrwOpenKeepingFocus()<CR>
  nnoremap <silent><buffer> l :call <SID>NetrwOpenKeepingFocus()<CR>
  let t:netrw_bufnr = bufnr('%')
  call s:ResizeNetrwTree()
endfunction

function! s:ClearNetrwRefs() abort
  if exists('t:netrw_winid') && win_id2win(t:netrw_winid) == 0
    unlet t:netrw_winid
  endif
  if exists('t:netrw_prevwinid') && win_id2win(t:netrw_prevwinid) == 0
    unlet t:netrw_prevwinid
  endif
  if exists('t:netrw_bufnr') && bufwinnr(t:netrw_bufnr) == -1
    unlet t:netrw_bufnr
  endif
endfunction

augroup netrwTreeSettings
  autocmd!
  autocmd FileType netrw call s:SetupNetrwMappings()
  autocmd BufWinLeave netrw call s:ClearNetrwRefs()
  autocmd User NetrwRefresh call s:ResizeNetrwTree()
augroup END

nnoremap <silent> <Leader>e :call ToggleNetrwTree()<CR>
