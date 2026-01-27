# GNOME home-manager profile
# dconf settings for usability + RDP
{ config, pkgs, lib, ... }:
{
  imports = [
    ./theming.nix
    ./apps.nix
  ];

  dconf.enable = true;

  dconf.settings = {
    # Dark mode
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      font-name = "Noto Sans 11";
      monospace-font-name = "JetBrainsMono Nerd Font 11";
      clock-show-weekday = true;
      clock-format = "24h";
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    # Keyboard layouts
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "tr" ])
      ];
      xkb-options = [ "grp:win_space_toggle" ];
    };

    # Window management
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
      num-workspaces = 6;
      button-layout = "close,minimize,maximize:appmenu";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = true;
      # Enable fractional scaling (125%, 150%, 175%, etc.)
      # scale-monitor-framebuffer: Wayland fractional scaling
      # xwayland-native-scaling: XWayland apps render at native scale (GNOME 47+)
      experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling" ];
    };

    # Keybindings
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
    };

    # Custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "kitty";
      binding = "<Super>Return";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "File Manager";
      command = "nautilus";
      binding = "<Super>e";
    };

    # Nautilus preferences
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      show-hidden-files = true;
    };

    # Night light
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };

    # Shell settings
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        appindicator.extensionUuid
        tiling-shell.extensionUuid
      ];
      favorite-apps = [
        "brave-browser.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"
        "code.desktop"
      ];
    };
  };

  # GNOME extensions
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    tiling-shell
  ];
}
