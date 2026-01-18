# Hyprland theming
# Catppuccin, GTK, Qt, cursor, and terminal
{ config, pkgs, lib, ... }:
{
  # Terminal: ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 11;
      window-padding-x = 10;
      window-padding-y = 10;
      background = "1e1e2e";  # Catppuccin Mocha base - prevents white flash
    };
  };

  # Catppuccin theming
  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    ghostty.enable = true;
  };

  # GTK settings
  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      size = 11;
    };
  };

  # Qt theming (use Breeze to avoid Qt5 dependencies)
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };

  # Cursor theme
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
