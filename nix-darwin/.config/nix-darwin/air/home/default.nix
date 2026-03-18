{ pkgs, ... }:

{
  imports = [
    ../../shared/home/base.nix
  ];

  home.username = "pablofernandezfranco";

  home.packages = with pkgs; [
    nodejs_20
    claude-code
  ];

  programs.zsh.shellAliases = {
    rebuild-air-system = "sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/air#air";
    update-air-system = "nix flake update && rebuild-air-system";
  };

  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;
  xdg.configFile."nvim".source = ./config/nvim;
  xdg.configFile."ghostty".source = ./config/ghostty;
}
