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
    nodejs_20
  ];

  programs.tmux = {
    enable = true;
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      vim = "nvim";
      v = "nvim";
      tmux-sessionizer = "~/.local/bin/tmux-sessionizer";
      lg = "lazygit";
    };

      initExtra = ''
        # Aquí va lo que ANTES estaba en tu .zshrc
        # (custom stuff que no tenga módulo HM)
        source ~/.zsh_custom
        source ~/.zsh_profile
        source ~/.zsh_work
      '';
  };

  programs.starship = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".tmux.conf".source = ./config/tmux/.tmux.conf;
  xdg.configFile."nvim".source = ./config/nvim;
  xdg.configFile."ghostty".source = ./config/ghostty;
}
