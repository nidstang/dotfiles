# Useful information

## Nvim
- nvim config requires nvim (of course)
- for nvim plugins to be installed, it requires packer (you can installed from the official page)
- to install plugin just go to lua/nidstang/packer and source it. Then just run :PackerSync
- it's strongly recommended to have nodejs/npm installed before :PackerSync, so lsp-server will be installed correctly at first
- some keymaps are ready to work under tmux

## Shells
- I'm using mostly zsh, so the bashrc will keep outdated
- Also, I'm using oh my zsh to get my zsh configured and to use some great plugins!
- zsh must be installed (it comes with arch, which is my distribution but maybe you have to install it for debian)
- $SHELL must be pointed to /bin/zsh in order to everything work as expected
- zshrc keeps the basic zsh configuration
- zsh_profile keeps my custom profile config
- also a .zsh_work will be sourced but I keep it outside this repo

## Tmux
- I'm a only-screen-at-the-time person. So tmux for me is a must
- I got configured the tmux-sessionizer that I learnt from theprimegean user (so, all credit to him)

## Bin
- I keep here my tmux-sessionizer

## Vim
- My old vim configuration. Since I'm using neovim right now I won't be updating it but it's perfectly working


# Important
I use 'stow' to create slinks to all these files so I do not have to be updating files around
