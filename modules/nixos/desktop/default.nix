# Desktop environment module
# KDE Plasma with RDP for remote access
{ config, lib, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./kde.nix
  ];
}
