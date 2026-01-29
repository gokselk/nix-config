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

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, catppuccin, llm-agents, ... }@inputs:
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
            ./profiles/core
            ./profiles/shell
            ./profiles/cli
            ./users/${username}
          ] ++ extraModules;
        };
    in
    {
      homeConfigurations = {
        # Main homelab server (headless Incus host)
        "goksel@hl-node01" = mkHome {
          username = "goksel";
          system = "x86_64-linux";
          hostname = "hl-node01";
        };
      };
    };
}
