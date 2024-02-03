inoremap jj <Esc>
cnoremap jj <Esc>

syntax enable

set mouse=a
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set guicursor=""
set hidden
set expandtab
set smartindent
set nu
set nohlsearch

" history stuffs
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

set incsearch
set nospell
set scrolloff=8
set smartcase
set splitbelow

set clipboard^=unnamed,unnamedplus

let mapleader = " "

let g:netrw_altv=0
let g:netrw_browse_split=2
let g:netrw_winsize=75

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>pv <bar> :Lexplore <bar> :vertical resize 30<CR>
nnoremap <leader>n  ^
