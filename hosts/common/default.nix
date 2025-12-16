# Common configuration shared across all hosts
{ config, lib, pkgs, ... }:
{
  imports = [
    ./users.nix
  ];

  # Locale and timezone
  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  # Console keymap
  console.keyMap = "us";
}
