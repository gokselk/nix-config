# User-specific configuration for goksel
{ config, pkgs, lib, ... }:
{
  # Home directory (auto-detected based on system)
  home.username = "goksel";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/goksel"
    else "/home/goksel";

  # User-specific packages
  home.packages = with pkgs; [
    # Add user-specific packages here
  ];

  # User-specific git config (if different from base)
  # programs.git.userEmail = "different@email.com";
}
