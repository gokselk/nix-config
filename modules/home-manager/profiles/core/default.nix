# Core home-manager configuration
# Foundational settings for all users/systems
{ config, pkgs, lib, ... }:
{
  imports = [
    ./git.nix
  ];

  # Home Manager version
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    MANPAGER = "nvim +Man!";
  };

  # Add ~/.local/bin to PATH (for user-installed binaries like Claude Code)
  home.sessionPath = [ "$HOME/.local/bin" ];

  # XDG directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
