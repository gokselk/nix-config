# Hyprland desktop environment profile
# Wayland compositor with full desktop stack
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./compositor.nix
    ./theming.nix
    ./bar.nix
    ./launcher.nix
    ./services.nix
    ./apps.nix
  ];
}
