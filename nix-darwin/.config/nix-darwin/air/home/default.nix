{ config, pkgs, ... }:

{
  home.username = "pablofernandezfranco";
  home.stateVersion = "24.05";
  home.enableNixpkgsReleaseCheck = false;

  home.sessionPath = [
    "/etc/bin"
    # "/etc/profiles/per-user/${config.home.username}/bin"
    # "/run/current-system/sw/bin"
  ];

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
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      tmux-sessionx
      tmux-floax
    ];
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

      initContent = ''
        ## Esto lo tengo que ir migrando
        source ~/.zsh_profile

        # --- ssh-agent (start if needed) ---
        if [[ -z "$SSH_AUTH_SOCK" ]]; then
          # reuse a persistent agent socket
          export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"

          if ! ssh-add -l >/dev/null 2>&1; then
            rm -f "$SSH_AUTH_SOCK"
            ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
          fi
        fi
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
  # home.file.".zprofile".text = ''
  #   if [ -e /etc/static/zshrc ]; then
  #     source /etc/static/zshrc
  #   fi
  # '';
}
