{
  description = "Pablo nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nikitabobko-aerospace = {
        url = "github:nikitabobko/homebrew-tap";
        flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, nikitabobko-aerospace }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.starship
          pkgs.alacritty
          pkgs.rustup
          pkgs.jetbrains.idea-ultimate
          pkgs.vscode
          pkgs.pre-commit
          pkgs.fzf
          pkgs.ripgrep
          pkgs.glow
          pkgs.zoxide
          pkgs.lazygit
          pkgs.obsidian
          pkgs.stow
          pkgs.bat
          pkgs.mkalias
          pkgs.tmux
        ];
      
      system.activationScripts.applications.text = let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = "/Applications";
          };
        in
          pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
              '';

      programs.zsh.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          # dock.persistent-others = [
          #     "~/Downloads"
          #     "~/workspace"
          # ];
          finder.AppleShowAllExtensions = true;
          finder.CreateDesktop = false;
          screencapture.location = "~/Pictures/screenshots";
          NSGlobalDomain."com.apple.sound.beep.volume" = 0.00;
          NSGlobalDomain."com.apple.mouse.tapBehavior" = 1; # eanbles tap to clikc
          controlcenter.BatteryShowPercentage = true;
      };

      homebrew = {
          enable =  true;
	  brews = [
            "neovim"
	  ];
          casks = [
            "google-chrome"
            "wezterm"
            "aerospace"
          ];
          onActivation.cleanup = "zap";
      };

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#pro
    darwinConfigurations."pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
            nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "pffranco";
                autoMigrate = true;

                taps = {
                    "nikitabobko/homebrew-tap" = nikitabobko-aerospace;
                };
            };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."pro".pkgs;
  };
}
