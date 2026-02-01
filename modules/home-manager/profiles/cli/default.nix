# CLI tools and utilities
# Starship prompt and common command-line tools
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./files.nix
    ./media.nix
  ];

  # Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Common CLI packages
  home.packages = with pkgs; [
    # System monitoring
    htop
    btop

    # Search and find
    ripgrep
    fd

    # Data processing
    jq
    yq-go

    # File viewing
    tree
    bat
    eza # Modern ls replacement

    # System info
    fastfetch

    # Archives
    unzip
    zip
    p7zip
  ];
}
