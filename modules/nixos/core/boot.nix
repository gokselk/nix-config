# Bootloader configuration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Use systemd-boot for UEFI systems
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
}
