" Display
set number
set relativenumber
set showmatch
set wrap
set scrolloff=15
set colorcolumn=80

" Editing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Search
set hlsearch
set incsearch

" Files
set clipboard=unnamedplus
set noswapfile
set nobackup
set hidden
set autoread

" Encoding
set encoding=utf-8
set updatetime=50

" Keymaps
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-w> :w<CR>
inoremap <C-w> <Esc>:w<CR>gi
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>
