# Tailscale VPN configuration
{ config, lib, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    # Enable subnet routing and exit node capability
    useRoutingFeatures = "server";
  };

  # Required for Tailscale exit node functionality
  networking.firewall.checkReversePath = "loose";

  # Tailscale CLI
  environment.systemPackages = [ pkgs.tailscale ];
}
