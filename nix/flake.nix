{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

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
        ];
      };
    };

    homeConfigurations = {
      "rajesh" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/home.nix];
      };
    };
  };
}
