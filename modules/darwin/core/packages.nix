# Essential system packages for Darwin
# User CLI tools are in home-manager
{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    git
    curl
    wget

    # Nix utilities
    home-manager
    just  # Task runner (see Justfile)
  ];

  # Enable zsh (default macOS shell)
  programs.zsh.enable = true;
}
