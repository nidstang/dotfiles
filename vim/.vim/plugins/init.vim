let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
     silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif


call plug#begin()
Plug 'tpope/vim-fugitive' " version control
Plug 'tpope/vim-surround' " vim plugin to wrap and unwrap characters
Plug 'tpope/vim-commentary' " gc to comment out
Plug 'pangloss/vim-javascript'
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_working_path_mode = 0 " make ctrlp work from current dir
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'szw/vim-g'
Plug 'jiangmiao/auto-pairs'
Plug 'jamesroutley/vim-logbook'
Plug 'sheerun/vim-polyglot'   " syntax highlighting in most languages
Plug 'crusoexia/vim-monokai'
Plug 'ternjs/tern_for_vim'
Plug 'w0rp/ale' " LINTER
Plug 'benmills/vimux' " Integration for vim and tmux
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

call plug#end()
