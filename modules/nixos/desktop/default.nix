# Desktop environment module
# Hyprland compositor with uwsm session management
{ config, lib, pkgs, ... }:
{
  imports = [
    ./graphics.nix
    ./hyprland.nix
  ];
}
