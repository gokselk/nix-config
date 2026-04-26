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

    # Home Manager (as module)
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

    # ssh2incus - SSH server for Incus instances
    ssh2incus = {
      url = "path:./pkgs/ssh2incus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ephemeral root: explicit persist list, everything else rolled back on boot
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      home-manager,
      sops-nix,
      catppuccin,
      ssh2incus,
      ...
    }@inputs:
    let
      # Common home-manager settings
      homeManagerConfig = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.sharedModules = [
          sops-nix.homeManagerModules.sops
          catppuccin.homeModules.catppuccin
        ];
      };

      # Helper function to create NixOS configurations
      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit (self) outputs;
          };
          modules = [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ssh2incus.nixosModules.default
            inputs.impermanence.nixosModules.impermanence
            homeManagerConfig
            ./hosts/common
            ./hosts/${hostname}
          ]
          ++ extraModules;
        };

      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      # Formatter for `nix fmt`
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      nixosConfigurations = {
        # Main homelab server: Nipogi E3B (AMD Ryzen 6800H)
        hl-node01 = mkHost {
          hostname = "hl-node01";
          system = "x86_64-linux";
        };
      };
    };
}
