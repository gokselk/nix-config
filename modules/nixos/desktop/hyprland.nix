# Hyprland compositor with uwsm session management
{ config, lib, pkgs, ... }:
let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";

  bravePolicy = {
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
in
{
  # Silence kernel console messages after boot (keeps boot verbose, stops spam on tuigreet)
  boot.consoleLogLevel = 0;

  # Brave browser policies (must be in /etc for Linux)
  environment.etc."brave/policies/managed/policies.json".text = builtins.toJSON bravePolicy;
  # Hyprland with built-in uwsm integration (NixOS 24.11+)
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # greetd with tuigreet
  services.greetd = {
    enable = true;
    vt = 2;  # Use VT2 to avoid kernel message spam on VT1
    settings.default_session = {
      command = "${tuigreet} --time --remember --remember-session --sessions ${sessions}";
      user = "greeter";
    };
  };

  # PAM for screen locking (hyprlock)
  security.pam.services.hyprlock = {};

  # Polkit for privilege escalation dialogs
  security.polkit.enable = true;

  # PipeWire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # D-Bus
  services.dbus.enable = true;

  # XDG portals for Wayland apps
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

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
