# Bash configuration
{ config, pkgs, lib, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}
