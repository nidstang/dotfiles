{ pkgs, ... }:

{
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
      source ~/.zsh_profile

      if [[ -z "$SSH_AUTH_SOCK" ]]; then
        export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"

        if ! ssh-add -l >/dev/null 2>&1; then
          rm -f "$SSH_AUTH_SOCK"
          ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null
        fi
      fi

      bindkey -s '^f' "tmux-sessionizer\n"
    '';
  };

  programs.starship.enable = true;

  programs.zoxide.enable = true;

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file.".claude/skills/interview-me/SKILL.md".source =
    ../files/claude/skills/interview-me/SKILL.md;
  home.file.".claude/skills/prd-to-plan/SKILL.md".source =
    ../files/claude/skills/prd-to-plan/SKILL.md;
  home.file.".claude/skills/write-a-prd/SKILL.md".source =
    ../files/claude/skills/write-a-prd/SKILL.md;
  xdg.configFile."television/config.toml".source = ../files/television/config.toml;
  xdg.configFile."television/cable/formulas.toml".source = ../files/television/cable/formulas.toml;
  xdg.configFile."television/cable/casks.toml".source = ../files/television/cable/casks.toml;
}
