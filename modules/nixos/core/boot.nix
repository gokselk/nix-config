# Bootloader configuration
{ config, lib, pkgs, ... }:
{
  # Use systemd-boot for UEFI systems
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Limit number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  # Hide systemd-boot menu (hold key to show)
  boot.loader.timeout = 0;

  # Quiet boot (suppress messages before Plymouth)
  boot.kernelParams = [ "quiet" "splash" "plymouth.use-simpledrm" ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
}
