{
  description = "A declarative Nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # my custom website
    mywebsite.url = "github:knoc-off/Website";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox add-ons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ { self, nixpkgs, home-manager, disko, ... }:
    let
      inherit (self) outputs;

      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    rec {
      # Packages for all systems
      packages = forAllSystems (system: import ./pkgs { inherit system nixpkgs; });

      # Overlays
      overlays = forAllSystems (system: import ./overlays { inherit system nixpkgs; });

      # NixOS modules
      nixosModules = import ./nixos/modules;

      # Home Manager modules
      homeManagerModules = import ./home-manager/modules;

      # Utility functions
      utils = import ./utils.nix { inherit nixpkgs; };

      devShells = forAllSystems (system: import ./shells { inherit system nixpkgs; });



    };
}

