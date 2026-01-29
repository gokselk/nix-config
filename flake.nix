{
  description = "Home Lab NixOS Infrastructure";

  inputs = {
    # Core nixpkgs (unstable for latest packages)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disk management for declarative partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (standalone)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin theming
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, sops-nix, catppuccin, ... }@inputs:
    let
      # Helper function to create NixOS configurations
      mkHost = { hostname, system ? "x86_64-linux", extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit (self) outputs;
          };
          modules = [
            disko.nixosModules.disko
            ./hosts/common
            ./hosts/${hostname}
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        # Main homelab server: Nipogi E3B (AMD Ryzen 6800H)
        hl-node01 = mkHost {
          hostname = "hl-node01";
          system = "x86_64-linux";
        };
      };

      # Expose for external use
      overlays.default = import ./overlays;
    };
}
