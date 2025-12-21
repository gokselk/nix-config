# Common Darwin configuration shared across all Macs
{ config, lib, pkgs, inputs, ... }:
{
  # Timezone
  time.timeZone = "Europe/Istanbul";

  # Networking (hostname set per-host)
  networking.localHostName = config.networking.hostName;

  # Security - Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # System version
  system.stateVersion = 4;

  # User configuration
  users.users.goksel = {
    name = "goksel";
    home = "/Users/goksel";
  };

  # Home-manager user configuration
  home-manager.users.goksel = { pkgs, ... }: {
    imports = [
      ../../home/profiles/core
      ../../home/profiles/shell
      ../../home/profiles/cli
      ../../home/profiles/development
      ../../home/profiles/darwin
      ../../home/users/goksel
    ];

    home.stateVersion = "24.11";
  };
}
