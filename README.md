## List of packages
- nodejs_20
- tmux
- neovim
- starship
- alacritty
- fzf
- bat
- stow
- mkalias
- obsidian

## List of casks
- iina

## Getting started

### Pre requirements
All packages are defined declaratively using nix and flakes, so we need to have this following configured:

- Nix: https://nix.dev/install-nix
- Nix darwin: https://github.com/LnL7/nix-darwin

Also, homebrew is managed through nix and it will be installed/migrated when you build the system


### Build the system
Firstly, you need to update the username of your system in ~/dotfiles/nix-darwin/.config/nix-darwin/user.nix

It's very important that you edit this file but not to push changes if you are using this configuration for multiples computers (which is my case)

This happens because files that are not commited will be ignored by nix

To build the system from my macbook air (personal), run:
```bash
darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/air#air
```

To build the system from my macbook pro (work), run:
```bash
darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/pro#pro
```

Or if you are installing nix-darwin for the first time:
```bash
nix run nix-darwin -- switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/air#air
```
Important: Not use the path ~/.config/nix-darwin because nix does not seem to read well the symlink

Note: air is the configuration for my macbook air, that I also use in my macbook pro from work 

if you are getting an error aboud nix-command is disabled, you have 2 options:
1. symlink (with stow or not) the nix configuration of this repo to ~/.config/nix
2. pass the --extra-experimental-features "nix-command flakes" when you run the command above

### Link the .dotfiles
Clone this repo into ~. Then go to it and execute stow for every folder, like so:
- stow alacritty
- stow tmux
- stow nvim
- stow nix
- stow nix-darwin

## Install all plugins for neovim
Once you have stowed de nvim folder, you need to run:
```bash
v ~/dotfiles/nvim/.config/nvim/nidstang/packer.lua
```

And the run the following commands:
:source
:PackerSync

Then you only need to wait for all the plugins to be installed

## Install all plugins for tmux
Firstly you need to clone the tmp plugin system:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Now, in order to not get any errors, you should exit tmux and run:
```bash
tmux kill-server
```

That will kill all active sessions

Then run tmux again and reload tmux enviroment config:
```bash
tmux source ~/.tmux.conf
```

Finally run: prefix+I for installing all plugins defined on .tmux.conf
