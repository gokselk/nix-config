# Network configuration for mini
# Bridge for VM/container networking
{ ... }:
{
  networking.useDHCP = false;

  # Bridge with physical NIC - inherits MAC from eno1 automatically
  networking.bridges.vmbr0 = {
    interfaces = [ "eno1" ];
    rstp = false;
  };

  networking.interfaces.vmbr0 = {
    useDHCP = true;  # Static DHCP lease on router
  };

  # Disable wireless
  networking.interfaces.wlp3s0.useDHCP = false;
}
