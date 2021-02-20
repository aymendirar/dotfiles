inoremap jj <Esc>
cnoremap jj <Esc>

syntax on
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" plugins
Plug 'neoclide/coc.nvim'
Plug 'mbbill/undotree'
Plug 'vim-utils/vim-man'
Plug 'tpope/vim-fugitive'
Plug 'gabrielelana/vim-markdown'

" colors
Plug 'morhetz/gruvbox'

call plug#end()

colorscheme gruvbox
set background=dark

let mapleader = " "

let g:netrw_browse_split=2
let g:netrw_winsize=25

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>n  ^