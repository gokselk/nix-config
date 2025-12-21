# Mini host configuration
# AMD Ryzen 6800H, 16GB RAM, 500GB SSD
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    # Host-specific
    ./disk-config.nix
    ./hardware.nix
    ./networking.nix
    ./k3s.nix
    ./incus.nix

    # Common modules
    ../../modules/nixos/core
    ../../modules/nixos/networking/firewall.nix
    ../../modules/nixos/networking/ssh.nix
    ../../modules/nixos/networking/tailscale.nix
    ../../modules/nixos/storage
    ../../modules/nixos/secrets
    ../../modules/nixos/desktop
  ];

  # Hostname
  networking.hostName = "mini";

  # ZFS requires a unique hostId
  # Generate with: head -c 8 /etc/machine-id
  networking.hostId = "962c5737";

  # System state version (do not change after install)
  system.stateVersion = "24.11";
}
