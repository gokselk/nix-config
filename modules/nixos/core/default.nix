# Core NixOS configuration module
{ config, lib, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./packages.nix
    ./boot.nix
  ];
}
