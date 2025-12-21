# WSL host configuration (future)
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
  networking.hostName = "desktop-wsl";

  # System state version
  system.stateVersion = "24.11";
}
