{
  description = "Home Lab NixOS Infrastructure";

  inputs = {
    # Core nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disk management for declarative partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager (standalone)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # WSL support (future)
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management (future)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, disko, home-manager, nixos-wsl, sops-nix, ... }@inputs:
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
        # Main target: Mini PC (AMD Ryzen 6800H)
        mini = mkHost {
          hostname = "mini";
          system = "x86_64-linux";
        };

        # Future: WSL instance on Windows desktop
        desktop-wsl = mkHost {
          hostname = "desktop-wsl";
          system = "x86_64-linux";
          extraModules = [ nixos-wsl.nixosModules.wsl ];
        };
      };

      # Expose for external use
      overlays.default = import ./overlays;
    };
}
