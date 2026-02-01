# Network configuration for hl-node01
# Bridge for VM/container networking
_: {
  networking.useDHCP = false;

  # Enable systemd-resolved for proper DNS integration with Tailscale
  services.resolved.enable = true;

  # Bridge with physical NIC - inherits MAC from eno1 automatically
  networking.bridges.vmbr0 = {
    interfaces = [ "eno1" ];
    rstp = false;
  };

  networking.interfaces.vmbr0 = {
    useDHCP = true; # Static DHCP lease on router
  };

  # Disable wireless
  networking.interfaces.wlp3s0.useDHCP = false;
}
