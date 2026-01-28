# GNOME Desktop Environment
# Minimal GNOME with Remote Desktop (RDP) support
{ config, lib, pkgs, ... }:
{
  # Apply user display settings to GDM login screen
  systemd.tmpfiles.rules = [
    "d /run/gdm/.config 0711 gdm gdm -"
    "L+ /run/gdm/.config/monitors.xml - - - - /home/goksel/.config/monitors.xml"
  ];

  # Plymouth boot splash (smoother boot + login transitions)
  boot.plymouth.enable = true;

  # GDM Display Manager (Wayland)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  # GNOME Desktop
  services.desktopManager.gnome.enable = true;

  # Disable GNOME bloat
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;

  # GNOME Remote Desktop (RDP server)
  # Note: Must also enable in Settings → Sharing → Remote Desktop after first login
  services.gnome.gnome-remote-desktop.enable = true;

  # Essential tools
  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];

  # PipeWire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Polkit for privilege dialogs
  security.polkit.enable = true;

  # D-Bus and portals
  services.dbus.enable = true;
  xdg.portal.enable = true;

  # Fonts (reuse from hyprland.nix)
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

  # Brave browser policies
  environment.etc."brave/policies/managed/policies.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    TorDisabled = true;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    BravePlaylistEnabled = false;
    IPFSEnabled = false;
    BraveP3AEnabled = false;
    BraveWebDiscoveryEnabled = false;
    BraveStatsPingEnabled = false;
    PasswordManagerEnabled = false;
    DnsOverHttpsMode = "automatic";
  };

  # Firewall: Open RDP port
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
