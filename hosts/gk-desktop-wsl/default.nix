# gk-desktop-wsl - WSL instance on Windows desktop
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    # Only import nix and packages for WSL (no boot config)
    ../../modules/nixos/core/nix.nix
    ../../modules/nixos/core/packages.nix
  ];

  # WSL-specific configuration
  wsl = {
    enable = true;
    defaultUser = "goksel";
    startMenuLaunchers = true;

    # WSL interop settings
    interop = {
      includePath = true;
      register = true;
    };
  };

  # Hostname
  networking.hostName = "gk-desktop-wsl";

  # System state version
  system.stateVersion = "24.11";
}
