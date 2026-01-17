# GNOME desktop profile
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    gnome-tweaks
  ];
}
