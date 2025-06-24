{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, nixpkgs }:
  let
    configuration = { pkgs, config,  ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget

      environment.systemPackages = with pkgs;

let customNeomutt = pkgs.neomutt.overrideAttrs (old: rec {
        src = pkgs.fetchFromGitHub {
          owner = "neomutt";
          repo = "neomutt";
          rev = "e4b57e076df382a02f1e0125b8e08da9340bcc1a"; 
            sha256 = "z5FBh9EASPT8gQBHpz4wzzajAPWIyYoz3i/RBGYpPJ8=";
        };
      });
in
[
          (customNeomutt.override { enableLua = true; })
          pkgs.vim
          pkgs.neovim
          pkgs.mkalias
          pkgs.tmux
          pkgs.kitty
          pkgs.bat
          pkgs.dust
          pkgs.fzf
          pkgs.gh
          pkgs.git
          pkgs.isync
          pkgs.jq
          pkgs.pandoc
          pkgs.tig
          pkgs.ydiff
          pkgs.ripgrep
          pkgs.lua
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      homebrew = {
        enable = true;
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

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

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Air
    darwinConfigurations."MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "rsh";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
      ];
    };
  };
}
