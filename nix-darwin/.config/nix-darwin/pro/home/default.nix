{ pkgs, ... }:

{
  imports = [
    ../../shared/home/base.nix
  ];

  home.username = "pffranco";

  home.packages = with pkgs; [
    fnm
    pre-commit
    glow
    fd
    television
  ];

  programs.zsh.shellAliases = {
    rebuild-pro-system = "sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin/.config/nix-darwin/pro#pro";
    update-pro-system = "nix flake update && rebuild-pro-system";
    # oc = "NODE_EXTRA_CA_CERTS="/ruta/a/tu/empresa-ca.pem";
  };

  programs.zsh.initExtra = ''
    eval "$(fnm env --use-on-cd)"
  '';

  home.file.".tmux.conf".source = ../../air/home/config/tmux/.tmux.conf;
  xdg.configFile."nvim".source = ../../air/home/config/nvim;
  xdg.configFile."ghostty".source = ../../air/home/config/ghostty;
  xdg.configFile."opencode/opencode.json".source = ./config/opencode/opencode.json;
}
