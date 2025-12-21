# NetworkManager configuration (for desktops)
{ ... }:
{
  networking.networkmanager.enable = true;

  # Enable nftables (modern firewall backend)
  networking.nftables.enable = true;
}
