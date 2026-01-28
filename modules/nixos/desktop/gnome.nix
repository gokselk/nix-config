# GNOME Desktop Environment
# Minimal GNOME with Remote Desktop (RDP) support
{ config, lib, pkgs, ... }:

let
  # GDM monitors.xml - inline to avoid pure eval issues
  # GNOME 49+ path: /var/lib/gdm/seat0/config/monitors.xml
  monitorsXml = pkgs.writeText "gdm-monitors.xml" ''
    <monitors version="2">
      <configuration>
        <layoutmode>logical</layoutmode>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1.5</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-2</connector>
              <vendor>GBT</vendor>
              <product>M27U</product>
              <serial>23323B000512</serial>
            </monitorspec>
            <mode>
              <width>3840</width>
              <height>2160</height>
              <rate>143.999</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
    </monitors>
  '';
in
{
  # Apply user display settings to GDM login screen (GNOME 49+ path)
  systemd.tmpfiles.rules = [
    "d /var/lib/gdm/seat0/config 0755 gdm gdm -"
    "L+ /var/lib/gdm/seat0/config/monitors.xml - - - - ${monitorsXml}"
  ];

  # Plymouth boot splash (smoother boot + login transitions)
  boot.plymouth.enable = true;

  # GDM Display Manager (Wayland)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  # GNOME Desktop
  services.desktopManager.gnome.enable = true;

  # Set experimental-features globally (required for GDM compatibility with fractional scaling)
  # Without this, monitors.xml is incompatible between GDM and user session, causing flicker
  # lockAll prevents user-db from overriding these settings
  programs.dconf.profiles.gdm.databases = [{
    lockAll = true;
    settings."org/gnome/mutter".experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling" ];
  }];

  # Disable GNOME games
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
