# Networking configuration module
{ config, lib, pkgs, ... }:
{
  imports = [
    ./firewall.nix
    ./tailscale.nix
    ./ssh.nix
  ];

  # Use NetworkManager for network management
  networking.networkmanager.enable = true;

  # Enable nftables (modern firewall backend)
  networking.nftables.enable = true;
}
