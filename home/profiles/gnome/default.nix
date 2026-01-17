# GNOME desktop profile
# Theming and GNOME-specific settings
{ config, pkgs, lib, ... }:
{
  imports = [ ../theming ];

  # GNOME-specific packages
  home.packages = with pkgs; [
    gnome-tweaks
  ];
}
