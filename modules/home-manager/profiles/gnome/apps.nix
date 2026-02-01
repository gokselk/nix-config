# GNOME desktop applications
# Packages, session variables, mpv
{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # Browser
    brave

    # Editor
    vscode-fhs

    # Media
    vlc
    spotify

    # Communication
    vesktop
    telegram-desktop

    # Productivity
    obsidian

    # Utilities
    bitwarden-desktop
    pavucontrol
  ];

  # Desktop environment variables
  home.sessionVariables = {
    BROWSER = "brave";
    TERMINAL = "kitty";
  };

  # mpv with gpu-next, vulkan, hq profile
  programs.mpv = {
    enable = true;
    config = {
      profile = "high-quality";
      vo = "gpu-next";
      gpu-api = "vulkan";
    };
  };
}
