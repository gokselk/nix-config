# Base NixOS configuration module
{ config, lib, pkgs, ... }:
{
  imports = [
    ./nix-settings.nix
    ./packages.nix
    ./boot.nix
  ];
}
