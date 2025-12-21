# File management CLI tools
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    yazi      # Terminal file manager
  ];
}
