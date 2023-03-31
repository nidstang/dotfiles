# Vim kickoff

In this repo you'll find my custom vim configuration and how to start to use it. I would use Visual Studio Code but since I've been introduced to vim I use it for everything and I love it.

If you find it difficult to start with the config you can use mine.



## Setup vim

Firstly you will need to install vim and gvim (it allows you to use + register to copy and paste to clipboard), so:

```bash
sudo apt-get install vim gvim
```



## Configure vim

Next, you have to clone this repo into ~/.config/vim and create a .vimrc file in your home with this content:

```bash
set nocompatible              " be iMproved, required
filetype off                  " required

source $HOME/.config/vim/plugins/init.vim
source $HOME/.config/vim/theme.vim
source $HOME/.config/vim/basics.vim
source $HOME/.config/vim/tabssize.vim
source $HOME/.config/vim/tabs.vim
source $HOME/.config/vim/copypaste.vim
source $HOME/.config/vim/plugins/conf/nerdtree.vim
source $HOME/.config/vim/plugins/conf/vim-multiple-cursors.vim
source $HOME/.config/vim/plugins/conf/ale.vim
source $HOME/.config/vim/plugins/conf/undo.vim
source $HOME/.config/vim/plugins/conf/coc.vim
source $HOME/.config/vim/plugins/conf/fzf.vim
source $HOME/.config/vim/plugins/conf/vim-rooter.vim

```



## Setup color theme

I am using **monokai** as my main color theme but feel free if you want to use another. **To install monokai just run**:

```bash
git clone https://github.com/sickill/vim-monokai
cd ./vim-monokai
mv colors/monokai.vim ~/vim/colors/monokai.vim
```



## Install plugins

Install the plugin manager. I know it is *deprecated* but I am using Vundle currently:

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Now, launch vim and execute:

```
:PluginInstall
```



And just it, you're ready to go :D





## Extra

For code completion I am using **coc.nvim** with these extensions: coc-css, coc-tsserver, coc-html, coc-json, coc-eslint.
More info:

https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions

https://github.com/neoclide/coc.nvim