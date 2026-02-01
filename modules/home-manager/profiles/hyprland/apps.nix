# Desktop applications
# Packages, session variables, XDG, mpv
{ config, pkgs, lib, ... }:
{
  # Wayland utilities and desktop applications
  home.packages = with pkgs; [
    # Screenshot tools
    grim
    slurp
    satty

    # Clipboard
    wl-clipboard
    cliphist

    # File manager
    yazi

    # Viewers
    zathura      # PDF/DJVU
    imv          # Images

    # Archive tools
    ouch        # Modern wrapper
    p7zip
    unrar

    # Audio control
    pavucontrol
    pamixer

    # Brightness control
    brightnessctl

    # Misc Wayland tools
    wlr-randr
    wev

    # Browser
    brave

    # Editor
    vscode-fhs

    # Media
    spotify

    # Communication
    vesktop
    telegram-desktop

    # Documents
    typst
    tinymist        # Typst LSP

    # Productivity
    obsidian

    # Screen recording/streaming
    obs-studio

    # Fonts
    corefonts      # Arial, Times New Roman, Courier New, etc.
    vista-fonts    # Calibri, Cambria, Consolas, etc.
    inter          # Modern UI font

    # Utilities
    qbittorrent-enhanced
    bitwarden-desktop
  ];

  # Desktop environment variables
  home.sessionVariables = {
    BROWSER = "brave";
    TERMINAL = "ghostty";
  };

  # mpv with gpu-next, vulkan, hq profile
  programs.mpv = {
    enable = true;
    config = {
      profile = "high-quality";
      vo = "gpu-next";
      gpu-api = "vulkan";
      hwdec = "vulkan";
    };
  };

}
