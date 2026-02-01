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
      confirm-close-surface = false;
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
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Tell apps to use dark mode via portal
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Qt theming (Adwaita Dark)
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
