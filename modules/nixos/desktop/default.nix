# Desktop environment module
# Hyprland Wayland compositor with uwsm session management
{ config, lib, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./hyprland.nix
  ];
}
