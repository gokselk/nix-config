# Hyprland theming
# Catppuccin, GTK, Qt, cursor, and terminal
{ config, pkgs, lib, ... }:
{
  # Terminal: kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      window_padding_width = 10;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
  };

  # Catppuccin theming
  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    kitty.enable = true;
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
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}
