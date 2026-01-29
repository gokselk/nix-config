# File management CLI tools
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yazi      # Terminal file manager
  ];
}
