" vim: set ts=2 sw=2 et :

let mapleader = " "
nnoremap ; :

if !exists("g:syntax_on")
  syntax enable
endif

execute pathogen#infect()

" General
" ------------------------------------------------------------------------------

set encoding=utf-8

set nocompatible                " get out of horrible vi-compatible mode
filetype indent on              " detect the type of file and load indent files
filetype plugin on              " load filetype plugins

" default to 4 spaces (damn you @shumphrey)
set tabstop=4 shiftwidth=4 expandtab

set autoindent                  " copy indent of current line when starting new
set cursorline                  " highlight screenline of the cursor
set formatoptions+=j            " Delete comment character when joining commented lines
set ignorecase smartcase        " case insensitive searching by default
set incsearch                   " incremental search-as-you-type
set modeline                    " override vim options per file
set number                      " display line numbers
set relativenumber              " line numbers relative to current cursor position
set ruler                       " show status bar with current file info
set scrolloff=5                 " number of context lines above and below cursor
set showmatch matchtime=4       " show matching brackets for 4 seconds
set smartindent                 " does the right thing (mostly) in programs
set smarttab                    " some tab voodoo
set splitbelow                  " more natural split behaviour
set splitright

" Super fancy status lines
set laststatus=2                " always show the status line
let g:airline_theme='powerlineish'
" let g:airline_left_sep=''
" let g:airline_right_sep=''
" let g:airline_section_z=''

" Theme / colours
" ------------------------------------------------------------------------------
if has('gui_running')
  set background=light
else
  set background=dark
endif

let g:solarized_termcolors=256
set t_Co=256
colorscheme solarized

" Spaces
" ------------------------------------------------------------------------------

" function! TrimWhiteSpace()
"     %s/\s\+$//e
" endfunction

" nnoremap <silent> <Leader>rts :call TrimWhiteSpace()<CR>

" autocmd FileWritePre    * :call TrimWhiteSpace()
" autocmd FileAppendPre   * :call TrimWhiteSpace()
" autocmd FilterWritePre  * :call TrimWhiteSpace()
" autocmd BufWritePre     * :call TrimWhiteSpace()

nnoremap <Leader>wc :%s/\s\+$//c<CR>
nnoremap <Leader>wa :%s/\s\+$//<CR>

" Tabs (using Leader as can't get CTRL+TAB to work)
" ------------------------------------------------------------------------------
" au TabLeave * let g:lasttab = tabpagenr()
" noremap <Leader><tab> :exe "tabn ".g:lasttab<cr>
" nnoremap <silent> <C-Tab> :exe "tabn ".g:lasttab<cr>
" vnoremap <silent> <C-Tab> :exe "tabn ".g:lasttab<cr>

" vimmux - https://github.com/benmills/vimux
" ------------------------------------------------------------------------------
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>p  :call VimuxRunCommand("clear; prove -l " . bufname("%"))<CR>

" Custom mappings
" ------------------------------------------------------------------------------
noremap <Leader>s   :!sort<CR>
noremap <Leader>t   :!perltidy<CR>
noremap <Leader>vrc :source ~/.vimrc<CR>

nnoremap <Leader>num :set relativenumber! number!<CR>
nnoremap <Leader>w   :w<CR>

nmap <Leader><Leader> V
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Highlighting
" ------------------------------------------------------------------------------

au BufReadPost *.ep set syntax=html
au BufReadPost *.tt,*.tt2 set syntax=tt2html
au BufReadPost cpanfile set syntax=perl

" Highlight *just* the 80th character when I exceed 80 characters
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
call matchadd('OverLength', '\%81v.', 100)

" Highlight trailing whitespace
call matchadd('ErrorMsg', '\s\+$', 100)

" FZF - https://github.com/junegunn/fzf.vim
" -----------------------------------------------------------------------------
set rtp+=~/.fzf

noremap <Leader>f  :FZF<CR>
noremap <Leader>b  :Buffers<CR>
noremap <Leader>bl :BLines<CR>
noremap <Leader>l  :Lines<CR>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Source local vimrc if it exists
" -----------------------------------------------------------------------------
if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" References
" ------------------------------------------------------------------------------
" Paul R: http://sprunge.us/KNCd
" Sensible: https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" Steven H: https://github.com/shumphrey/vimrc
" Thoughtbot: https://github.com/thoughtbot/dotfiles/blob/master/vimrc
