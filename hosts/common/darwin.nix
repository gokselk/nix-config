# Common Darwin configuration shared across all Macs
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Timezone
  time.timeZone = "Europe/Istanbul";

  # Networking (hostname set per-host)
  networking.localHostName = config.networking.hostName;

  # Security - Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System version
  system.stateVersion = 4;

  # Primary user for user-scoped system defaults and homebrew
  system.primaryUser = "goksel";

  # User configuration
  users.users.goksel = {
    name = "goksel";
    home = "/Users/goksel";
  };

  # Home-manager user configuration
  home-manager.users.goksel =
    { pkgs, ... }:
    {
      imports = [
        ../../modules/home-manager/profiles/core
        ../../modules/home-manager/profiles/shell
        ../../modules/home-manager/profiles/cli
        ../../modules/home-manager/profiles/development
        ../../modules/home-manager/profiles/darwin
        ../../modules/home-manager/users/goksel
      ];

      home.stateVersion = "26.05";
    };
}
