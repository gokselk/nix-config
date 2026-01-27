# Desktop environment module
# GNOME with Remote Desktop (RDP) support
{ config, lib, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./gnome.nix
  ];
}
