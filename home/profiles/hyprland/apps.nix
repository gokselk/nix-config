# Desktop applications
# Packages, session variables, XDG, mpv, brave policies
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
    nautilus

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
    vlc
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

    # KDE apps
    kdePackages.okular      # PDF/document viewer
    kdePackages.dolphin     # File manager
    kdePackages.gwenview    # Image viewer
    kdePackages.ark         # Archive manager
  ];

  # Desktop environment variables
  home.sessionVariables = {
    BROWSER = "brave";
    TERMINAL = "ghostty";
  };

  # XDG user directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
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

  # Brave debloat policies
  xdg.configFile."BraveSoftware/Brave-Browser/policies/managed/policies.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveNewsEnabled = false;
    BraveLeoAssistantEnabled = false;
    BraveVPNDisabled = true;
    MetricsReportingEnabled = false;
  };
}
