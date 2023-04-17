filetype plugin indent on
filetype plugin on
set omnifunc=syntaxcomplete#Complete

" --------------------------------
" Basic stuff
" --------------------------------
let g:mapleader = " " " Set leader to spacebar 
set spelllang=en_gb
set backspace=indent,eol,start " Bring backspace to life
set number          " Line numbers
set relativenumber  " Relative line numbers
set hlsearch        " Highlight whole word when searching
set ignorecase      " Ignore case when searching...
set smartcase       " ...except when serach query contains a capital letter
set autoread        " Auto load files if they change on disc
set smarttab
set smartindent
set expandtab
set encoding=utf-8
set cursorline
set autoread

" Save
map <leader><leader> :w<CR>

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><ESC> :noh<cr>
map <C-n> :NERDTreeToggle<CR>

" Disable swap files
set noswapfile

" Disable arrow keys in Escape mode
lsp
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Tmux
nmap <leader>g :silent !tmux neww sessionizer<CR>
