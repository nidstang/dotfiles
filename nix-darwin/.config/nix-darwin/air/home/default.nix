{ config, pkgs, ... }:

{
  home.username = "pablofernandezfranco";
  home.stateVersion = "24.05";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    ripgrep
    zoxide
    tree-sitter
    neovim
    bat
    fzf
    tmux
    lazygit
    carapace
    starship
    obsidian
  ];

  programs.tmux = {
    enable = true;
  };

  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;
  xdg.configFile."nvim".source = ./config/nvim;
}
