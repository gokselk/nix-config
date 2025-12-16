{
  description = "Home Manager configuration (standalone)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, catppuccin, ... }@inputs:
    let
      # Helper to create home configurations
      mkHome = { username, system, hostname, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            sops-nix.homeManagerModules.sops
            catppuccin.homeModules.catppuccin
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

      };
    };
}
