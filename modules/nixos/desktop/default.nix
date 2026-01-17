# Desktop environment module
# GNOME with RDP for remote access
{ config, lib, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./gnome.nix
  ];
}
