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
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Tell apps to use dark mode via portal
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Qt theming (Breeze Dark)
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };

  # Force Qt dark mode
  home.sessionVariables.QT_STYLE_OVERRIDE = "breeze-dark";

  # Cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };
}
