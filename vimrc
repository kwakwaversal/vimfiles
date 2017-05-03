" vim: set ts=2 sw=2 et :

" Paul R: http://sprunge.us/KNCd
" Steven H: https://github.com/shumphrey/vimrc

if !exists("g:syntax_on")
  syntax enable
endif

execute pathogen#infect()

" See https://github.com/Lokaltog/vim-powerline
let g:Powerline_symbols='fancy'

" General
" ------------------------------------------------------------------------------

set encoding=utf-8
let mapleader = ","

set nocompatible                " get out of horrible vi-compatible mode
filetype indent on              " detect the type of file and load indent files
filetype plugin on              " load filetype plugins

" default to 4 spaces (damn you @shumphrey)
set tabstop=4 shiftwidth=4 expandtab

set autoindent                  " copy indent of current line when starting new
set cursorline                  " highlight screenline of the cursor
set ignorecase smartcase        " case insensitive searching by default
set incsearch                   " incremental search-as-you-type
set modeline                    " override vim options per file
set number                      " display line numbers
set ruler                       " show status bar with current file info
set scrolloff=5                 " number of context lines above and below cursor
set showmatch matchtime=4       " show matching brackets for 4 seconds

" Super fancy status lines
set laststatus=2                " always show the status line
set statusline=%2*%n:%0*%f\ %2*%m\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}]\ 0x%B\ %12.(%c:%l/%L%)

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

" Custom mappings
" ------------------------------------------------------------------------------
nnoremap <Leader>p :!clear && prove -l %<CR>
nnoremap <Leader>s :!sort<CR>
nnoremap <Leader>t :!perltidy<CR>

" Highlighting
" ------------------------------------------------------------------------------

au BufReadPost *.ep set syntax=html

" Highlight *just* the 80th character when I exceed 80 characters
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
call matchadd('OverLength', '\%81v.', 100)

" Highlight trailing whitespace
call matchadd('ErrorMsg', '\s\+$', 100)
