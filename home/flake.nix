{
  description = "Home Manager configuration (standalone)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, ... }@inputs:
    let
      # Helper to create home configurations
      mkHome = { username, system, hostname, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs;
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          };
          modules = [
            sops-nix.homeManagerModules.sops
            ./profiles/base.nix
            ./users/${username}
          ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        # NixOS Mini PC
        "goksel@mini" = mkHome {
          username = "goksel";
          system = "x86_64-linux";
          hostname = "mini";
          extraModules = [
            ./profiles/development.nix
            ./profiles/hyprland.nix
          ];
        };

        # NixOS WSL
        "goksel@desktop-wsl" = mkHome {
          username = "goksel";
          system = "x86_64-linux";
          hostname = "desktop-wsl";
          extraModules = [ ./profiles/development.nix ];
        };

        # macOS (Apple Silicon)
        "goksel@macbook" = mkHome {
          username = "goksel";
          system = "aarch64-darwin";
          hostname = "macbook";
          extraModules = [ ./profiles/development.nix ];
        };

        # macOS (Intel)
        "goksel@macbook-intel" = mkHome {
          username = "goksel";
          system = "x86_64-darwin";
          hostname = "macbook";
          extraModules = [ ./profiles/development.nix ];
        };
      };
    };
}
