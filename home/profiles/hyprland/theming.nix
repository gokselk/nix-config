# Hyprland-specific theming (hyprcursor)
{ config, pkgs, lib, ... }:
{
  imports = [ ../theming ];

  # Enable hyprcursor for Hyprland
  home.pointerCursor.hyprcursor.enable = true;
}
