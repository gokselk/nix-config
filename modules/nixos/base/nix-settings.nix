# Nix daemon and flake settings
{ config, lib, pkgs, ... }:
{
  nix = {
    settings = {
      # Enable flakes, new nix command, and lazy-trees
      experimental-features = [ "nix-command" "flakes" "lazy-trees" ];

      # Optimize store automatically
      auto-optimise-store = true;

      # Allow trusted users to use substituters
      trusted-users = [ "root" "@wheel" ];

      # Use binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
