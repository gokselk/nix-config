# Essential system packages
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    git
    curl
    wget
    htop
    btop

    # File utilities
    tree
    ripgrep
    fd
    jq
    yq-go

    # Network utilities
    dig
    nmap
    tcpdump

    # System utilities
    pciutils
    usbutils
    lsof

    # Nix utilities
    home-manager
  ];

  # Enable vim as default editor
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
}
