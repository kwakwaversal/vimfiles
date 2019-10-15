" vim: set ts=2 sw=2 et :

let mapleader = " "
let maplocalleader = " "

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

set tabstop=2 shiftwidth=2 expandtab " default to 2 spaces

set autoindent                  " copy indent of current line when starting new
set backspace=2                 " allow backspace over autoindent, line breaks and start of insert
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
set updatetime=100              " write more often to swap (better GitGutter response)

" Super fancy status lines
set laststatus=2                " always show the status line
let g:airline_theme='powerlineish'
" let g:airline_left_sep=''
" let g:airline_right_sep=''
" let g:airline_section_z=''

set path+=**                    " fuzzy finding using vanilla vim and `:find`
set wildmenu                    " adds menu with multple `:find` or `:b` results
command! MakeTags !ctags -R .
nnoremap ,js :-1read $HOME/.vim/.skeleton.js<CR>

" https://shapeshed.com/vim-netrw/#nerdtree-like-setup
let g:netrw_altv=1              " open splits to the right
let g:netrw_banner=0            " disable annoying banner
let g:netrw_browse_split=4      " open in prior window
let g:netrw_liststyle=3         " tree view
let g:netrw_winsize = 25        " width of any opened files
" let g:netrw_list_hide=netrw_gitignore#Hide()    " does not work, needs work
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'  " does not work, needs work
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

" Theme / colours
" ------------------------------------------------------------------------------
if has('gui_running')
  set background=light
else
  set background=dark
endif

let g:solarized_termcolors=256
let g:solarized_visibility='high'
set t_Co=256
colorscheme solarized

" Spaces
" ------------------------------------------------------------------------------

nnoremap <Leader>wc :%s/\s\+$//c<CR>
nnoremap <Leader>wa :%s/\s\+$//<CR>

" ack.vim - https://github.com/mileszs/ack.vim
" ------------------------------------------------------------------------------
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

nmap <Esc>k :Ack! "\b<cword>\b" <CR>

" common(ish) macros
" ------------------------------------------------------------------------------
nmap \x :cclose<CR>
nmap \p :set paste!<CR>

" I think this toggles between the position of the last buffer
nmap <C-e> :e#<CR>

" vimmux - https://github.com/benmills/vimux
" ------------------------------------------------------------------------------
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vz :VimuxZoomRunner<CR>

" Custom mappings
" ------------------------------------------------------------------------------
noremap <Leader>bz   :tabnew %<CR><c-o>
noremap <Leader>s    :!sort<CR>
noremap <Leader>uuid :exe 'norm i' . system("echo -n $(uuidgen -r)")<CR>
noremap <Leader>vrc  :source ~/.vim/vimrc<CR>

nnoremap <Leader>num :set relativenumber! number! <bar> :GitGutterToggle<CR>
nnoremap <Leader>w   :w<CR>

noremap :Q :q        " remap common typos
noremap :W :w        " especially this one
noremap :X :x        "

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

vmap    <Leader>= mz gq `z<Left>     " format comment in visual mode
noremap <Leader>= mz vip gq `z<Left> " format comment paragraph in normal mode

" Highlighting
" ------------------------------------------------------------------------------

au BufReadPost *.ep set syntax=html
let g:sql_type_default = 'pgsql'

" Highlight *just* the 80th character when I exceed 80 characters
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
call matchadd('OverLength', '\%81v.', 100)

" Highlight trailing whitespace
" call matchadd('ErrorMsg', '\s\+$', 100)


" Backup outside of current path
" ------------------------------------------------------------------------------

set backupdir=~/.vim/tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim/tmp,~/tmp,/var/tmp,/tmp
set backupcopy=yes

" FZF - https://github.com/junegunn/fzf.vim
" ------------------------------------------------------------------------------
set rtp+=~/.fzf

noremap <Leader>a  :Ag<CR>
noremap <Leader>f  :FZF<CR>
noremap <Leader>bb :Buffers<CR>
noremap <Leader>bl :BLines<CR>
noremap <Leader>bt :BTags<CR>
noremap <Leader>l  :Lines<CR>
noremap <Leader><c-]> :Tags<CR>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" ALT-A CTRL-Q to select all and build quickfix list

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Plugins
" ------------------------------------------------------------------------------
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" Auto commands (included here to take precedence over plugins)
" -----------------------------------------------------------------------------
" Explicitly set the Ultisnips syntax for Dockerfile.snippets. When used with
" Dockerfile.vim (https://github.com/ekalinin/Dockerfile.vim), the `ftdetect`
" takes priority over Ultisnips' syntax highlighting option.
autocmd BufNewFile,BufRead Dockerfile.snippets set ft=snippets

augroup VIMRC
  autocmd!
  autocmd BufLeave *.css,*.scss normal! mC
  autocmd BufLeave *.feature    normal! mF
  autocmd BufLeave *.html       normal! mH
  autocmd BufLeave *.js,*.ts    normal! mJ
  autocmd BufLeave *.md         normal! mM
  autocmd BufLeave *.sql        normal! mS
  autocmd BufLeave *.snippets   normal! mU
  autocmd BufLeave *.yml,*.yaml normal! mY
  autocmd BufLeave .env*        normal! mE
  autocmd BufLeave *.vim        normal! mV
augroup END

" Source local vimrc if it exists
" ------------------------------------------------------------------------------
if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" References
" ------------------------------------------------------------------------------
" Paul R: http://sprunge.us/KNCd
" Sensible: https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" Statico: https://github.com/statico/dotfiles/blob/master/.vim/vimrc
" Steven H: https://github.com/shumphrey/vimrc
" Thoughtbot: https://github.com/thoughtbot/dotfiles/blob/master/vimrc
" Vim Without Plugins: https://www.youtube.com/watch?v=XA2WjJbmmoM
