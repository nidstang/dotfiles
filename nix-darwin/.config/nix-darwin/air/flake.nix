{
  description = "Pablo nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";

    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nikitabobko-aerospace = {
        url = "github:nikitabobko/homebrew-tap";
        flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, nikitabobko-aerospace, ... }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.stow
          pkgs.mkalias
        ];

      system.primaryUser = "pablofernandezfranco";
      users.users.pablofernandezfranco = {
        home = "/Users/pablofernandezfranco";
      };
      
      system.activationScripts.applications.text = let
          env = pkgs.buildEnv {
            name = "system-applications";
            paths = config.environment.systemPackages;
            pathsToLink = ["/Applications"];
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
      homebrew = {
          enable =  true;
          brews = [
            # do not install brews, only casks
            # cli programs should be installed by nixpkgs (flake.nix or default.nix)
            "opencode"
          ];
          taps = [
            "nikitabobko/homebrew-tap"  # this is managed by nix-homebrew but it must be here for "zap" to work
          ];
          casks = [
            "iina"
            "aerospace"
            "ghostty"
            "orbstack"
            "obsidian"
          ];
          onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
          };
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
    # $ darwin-rebuild build --flake .#air
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager

        {
            nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "pablofernandezfranco";
                autoMigrate = true;

                taps = {
                    "nikitabobko/homebrew-tap" = nikitabobko-aerospace;
                };
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;


            home-manager.users.pablofernandezfranco = import ./home;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."air".pkgs;
  };
}
