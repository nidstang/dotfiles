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
Firstly, you need to create a new file user.nix in ~/dotfiles/nix-darwin/.config/nix-darwin with this contents:
```nix
{
    username = "system_user";
}
```

Then just run:
```bash
darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin#air
```
Important: Not use the path ~/.config/nix-darwin because nix does not seem to read well the symlink

Note: air is the configuration for my macbook air, that I also use in my macbook pro from work 

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
