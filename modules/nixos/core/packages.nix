# Essential system packages
# User CLI tools (htop, ripgrep, jq, etc) are in home-manager
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    git
    curl
    wget

    # Network diagnostics (may need root)
    dig
    nmap
    tcpdump

    # Hardware diagnostics
    pciutils
    usbutils
    lsof

    # Nix utilities
    home-manager
    just # Task runner (see Justfile)
  ];

  # Enable vim as default editor
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # Allow running unpatched dynamic binaries (e.g., Claude Code)
  programs.nix-ld.enable = true;
}
