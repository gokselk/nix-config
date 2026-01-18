# KDE Plasma desktop profile
# Catppuccin theming for Plasma, cursors, and terminal
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
    };
  };

  # Catppuccin theming
  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    plasma.enable = true;
    ghostty.enable = true;
  };

  # Cursor theme
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
  };
}
