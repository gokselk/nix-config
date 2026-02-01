# Darwin system configuration modules
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./defaults.nix
    ./dock.nix
    ./finder.nix
  ];
}
