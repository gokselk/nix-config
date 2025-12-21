# Shell configuration
{ config, pkgs, lib, ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];
}
