# Hyprland-specific theming (hyprcursor)
{ config, pkgs, lib, ... }:
{
  imports = [ ../theming ];

  # Cursor theme
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
