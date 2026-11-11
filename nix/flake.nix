{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    xremap-flake.url = "github:xremap/nix-flake";
    claude-code.url = "github:sadjow/claude-code-nix";
    tome = {
      url = "git+file:///home/rajesh/dev/tome";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add grub2 themes to your inputs ...
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, grub2-themes, home-manager, ... }@inputs: let inherit (self) outputs;
  in
  {
    nixosConfigurations = {
      tiamat = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/tiamat/configuration.nix
          grub2-themes.nixosModules.default

          ./modules/xremap.nix

          # One nixos-rebuild updates system and user packages from the same nixpkgs.
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
            home-manager.users.rajesh = import ./home-manager/home.nix;
          }
        ];
      };
    };
  };
}
