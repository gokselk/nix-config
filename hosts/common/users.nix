# User definitions shared across all hosts
{ config, lib, pkgs, ... }:
{
  # Main user
  users.users.goksel = {
    isNormalUser = true;
    description = "Goksel";
    extraGroups = [
      "wheel"         # sudo access
      "networkmanager"
      "incus-admin"   # Incus container management
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHTkE/L8j4Awh0xfi38iz9oDKPX7Z+ZDOku6LcBh3tY goksel@users.noreply.github.com"
    ];
    # Allow passwordless sudo for wheel group
    # Password will be set on first login
    initialPassword = "changeme";
  };

  # Security: Allow wheel group to use sudo without password
  security.sudo.wheelNeedsPassword = false;

  # Home-manager base configuration (profiles added per-host)
  home-manager.users.goksel = { pkgs, ... }: {
    imports = [
      ../../modules/home/profiles/core
      ../../modules/home/profiles/shell
      ../../modules/home/profiles/cli
      ../../modules/home/users/goksel
    ];

    home.stateVersion = "24.11";
  };
}
