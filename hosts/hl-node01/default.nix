# hl-node01 - Main homelab server
# Nipogi E3B: AMD Ryzen 6800H, 16GB RAM, 500GB SSD
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Host-specific
    ./disk-config.nix
    ./hardware.nix
    ./networking.nix
    ./incus.nix
    ./k3s.nix

    # Common modules
    ../../modules/nixos/core
    ../../modules/nixos/networking/firewall.nix
    ../../modules/nixos/networking/ssh.nix
    ../../modules/nixos/networking/tailscale.nix
    ../../modules/nixos/storage
    ../../modules/nixos/secrets

    # Desktop
    ../../modules/nixos/desktop/hyprland.nix
  ];

  # Hostname
  networking.hostName = "hl-node01";

  # Disable suspend (server needs to stay awake)
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Disable NetworkManager (use declarative bridge networking)
  networking.networkmanager.enable = false;

  # ZFS requires a unique hostId
  # Generate with: head -c 8 /etc/machine-id
  networking.hostId = "962c5737";

  # System state version (do not change after install)
  system.stateVersion = "24.11";

  # Add Hyprland home-manager profile
  home-manager.users.goksel = {
    imports = [
      ../../modules/home-manager/profiles/hyprland
    ];

    # ssh2incus reads ~/.ssh/authorized_keys for host auth
    home.file.".ssh/authorized_keys" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHTkE/L8j4Awh0xfi38iz9oDKPX7Z+ZDOku6LcBh3tY gokselk.dev@gmail.com\n";
    };
  };
}
