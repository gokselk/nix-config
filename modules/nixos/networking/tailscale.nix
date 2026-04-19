# Tailscale VPN configuration
{ config, pkgs, ... }:
{
  services.tailscale = {
    enable = true;
    # Enable subnet routing and exit node capability
    useRoutingFeatures = "server";
    # Use authkey from sops-nix for automatic authentication
    authKeyFile = config.sops.secrets."tailscale/authkey".path;
    # Advertise as exit node and subnet router for Incus NAT network
    extraUpFlags = [
      "--advertise-exit-node"
      "--advertise-routes=10.10.10.0/24"
    ];
  };

  # Required for Tailscale exit node functionality
  networking.firewall.checkReversePath = "loose";

  # Tailscale CLI
  environment.systemPackages = [ pkgs.tailscale ];
}
