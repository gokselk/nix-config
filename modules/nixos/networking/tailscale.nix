# Tailscale VPN configuration
{ config, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    # Enable subnet routing and exit node capability
    useRoutingFeatures = "server";
    # Use authkey from sops-nix for automatic authentication
    authKeyFile = config.sops.secrets."tailscale/authkey".path;
  };

  # Required for Tailscale exit node functionality
  networking.firewall.checkReversePath = "loose";

  # Tailscale CLI
  environment.systemPackages = [ pkgs.tailscale ];
}
