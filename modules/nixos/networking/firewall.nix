# Firewall configuration
{ ... }:
{
  # Use nftables (modern firewall backend)
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;

    # Default: deny all incoming, allow all outgoing
    allowedTCPPorts = [
      22    # SSH
    ];

    allowedUDPPorts = [
      41641 # Tailscale
    ];

    # Allow ICMP (ping)
    allowPing = true;

    # Log denied connections (useful for debugging)
    logReversePathDrops = true;
  };
}
