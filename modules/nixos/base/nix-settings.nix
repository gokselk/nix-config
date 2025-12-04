# Nix daemon and flake settings
{ config, lib, pkgs, ... }:
{
  nix = {
    settings = {
      # Enable flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];

      # Optimize store automatically
      auto-optimise-store = true;

      # Allow trusted users to use substituters
      trusted-users = [ "root" "@wheel" ];

      # Use binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.flakehub.com"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.flakehub.com-1:t6986ugxCA+d/ZF9IeMzJkyqi5mDhvFIx7KA/ipulzE="
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
