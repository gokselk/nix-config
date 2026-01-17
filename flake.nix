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

    # nix-darwin for macOS
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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

    # Catppuccin theming
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, nix-darwin, nixos-wsl, sops-nix, catppuccin, ... }@inputs:
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

      # Helper function to create Darwin (macOS) configurations
      mkDarwin = { hostname, system ? "aarch64-darwin", extraModules ? [] }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit (self) outputs;
          };
          modules = [
            # Home-manager as darwin module
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
                catppuccin.homeModules.catppuccin
              ];
            }
            # Common darwin config
            ./hosts/common/darwin.nix
            # Darwin modules
            ./modules/darwin/core
            ./modules/darwin/system
            ./modules/darwin/homebrew
            # Host-specific config
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

        # WSL instance on Windows desktop
        gk-desktop-wsl = mkHost {
          hostname = "gk-desktop-wsl";
          system = "x86_64-linux";
          extraModules = [ nixos-wsl.nixosModules.wsl ];
        };
      };

      darwinConfigurations = {
        # Personal MacBook Air M2
        gk-air = mkDarwin {
          hostname = "gk-air";
          system = "aarch64-darwin";
        };
      };

      # Expose for external use
      overlays.default = import ./overlays;
    };
}
