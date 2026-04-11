{ pkgs, ... }:

{
  imports = [
    ../../shared/home/base.nix
  ];

  home.username = "pablofernandezfranco";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    fnm
    fd
    television
  ];

  programs.zsh.shellAliases = {
    rebuild-air-system = "sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/air#air";
    update-air-system = "nix flake update && rebuild-air-system";
  };

  programs.zsh.initExtra = ''
    eval "$(tv init zsh)"
    eval "$(fnm env --use-on-cd)"
  '';

  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;
  xdg.configFile."nvim".source = ./config/nvim;
  xdg.configFile."ghostty".source = ./config/ghostty;
}
