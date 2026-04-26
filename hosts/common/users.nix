# User definitions shared across all hosts
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Main user
  users.users.goksel = {
    isNormalUser = true;
    description = "Goksel";
    extraGroups = [
      "wheel" # sudo access
      "networkmanager"
      "incus" # Incus access
      "incus-admin" # Incus container management
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHTkE/L8j4Awh0xfi38iz9oDKPX7Z+ZDOku6LcBh3tY goksel@users.noreply.github.com"
    ];
    hashedPasswordFile = config.sops.secrets."users/goksel/hashedPassword".path;
  };

  users.mutableUsers = false;

  # Security: Allow wheel group to use sudo without password
  security.sudo.wheelNeedsPassword = false;

  # Home-manager base configuration (profiles added per-host)
  home-manager.users.goksel =
    { pkgs, ... }:
    {
      imports = [
        ../../modules/home-manager/profiles/core
        ../../modules/home-manager/profiles/shell
        ../../modules/home-manager/profiles/cli
        ../../modules/home-manager/profiles/development
        ../../modules/home-manager/users/goksel
      ];

      home.stateVersion = "26.05";
    };
}
