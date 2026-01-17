# GNOME desktop with RDP for remote access
{ config, lib, pkgs, ... }:
{
  # GNOME Desktop Environment (Wayland)
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.desktopManager.gnome.enable = true;

  # Disable NetworkManager (use declarative networking)
  networking.networkmanager.enable = false;

  # Enable gnome-remote-desktop for RDP access
  services.gnome.gnome-remote-desktop.enable = true;

  # PipeWire audio (required for screen sharing/RDP)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Firewall: allow RDP
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Remove some GNOME bloat
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    epiphany        # web browser
    geary           # email
    totem           # video player
    yelp            # help
  ];

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };
}
