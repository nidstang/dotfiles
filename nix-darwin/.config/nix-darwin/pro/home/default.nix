{ pkgs, ... }:

{
  imports = [
    ../../shared/home/base.nix
  ];

  home.username = "pffranco";

  home.packages = with pkgs; [
    nodejs_22
    pre-commit
    glow
  ];

  programs.zsh.shellAliases = {
    rebuild-pro-system = "sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/pro#pro";
    update-pro-system = "nix flake update && rebuild-pro-system";
  };

  home.file.".tmux.conf".source = ../../air/home/config/tmux/.tmux.conf;
  xdg.configFile."nvim".source = ../../air/home/config/nvim;
  xdg.configFile."ghostty".source = ../../air/home/config/ghostty;
}
