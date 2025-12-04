# Mini host configuration
# AMD Ryzen 6800H, 16GB RAM, 500GB SSD
{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./disk-config.nix
    ./hardware.nix
    ./networking.nix  # Host-specific: static IP + bridge

    # Modules
    ../../modules/nixos/base
    ../../modules/nixos/base/determinate.nix  # Determinate Nix
    ../../modules/nixos/networking/firewall.nix
    ../../modules/nixos/networking/tailscale.nix
    ../../modules/nixos/storage/zfs.nix
    ../../modules/nixos/services/ssh.nix
    ../../modules/nixos/services/incus.nix
    ../../modules/nixos/services/k3s.nix
  ];

  # Hostname
  networking.hostName = "mini";

  # ZFS requires a unique hostId
  # Generate with: head -c 8 /etc/machine-id
  networking.hostId = "962c5737";

  # System state version (do not change after install)
  system.stateVersion = "24.11";
}
