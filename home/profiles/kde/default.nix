# KDE Plasma desktop profile
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    krfb  # KDE remote desktop server
  ];
}
