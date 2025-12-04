# Network configuration for mini
# Bridge for VM/container networking, DHCP from router
{ config, lib, pkgs, ... }:
{
  # Disable NetworkManager - we use systemd-networkd
  networking.networkmanager.enable = false;

  # Use systemd-networkd for networking
  networking.useNetworkd = true;
  networking.useDHCP = false;
  systemd.network.enable = true;

  systemd.network = {
    # Bridge device
    netdevs."10-vmbr0" = {
      netdevConfig = {
        Name = "vmbr0";
        Kind = "bridge";
      };
      bridgeConfig = {
        STP = false;
        ForwardDelaySec = 0;
      };
    };

    # Physical interface - add to bridge
    networks."20-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig.Bridge = "vmbr0";
      linkConfig.RequiredForOnline = "enslaved";
    };

    # Bridge interface - DHCP
    networks."30-vmbr0" = {
      matchConfig.Name = "vmbr0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };

    # Wireless interface - disabled/manual
    networks."40-wlp3s0" = {
      matchConfig.Name = "wlp3s0";
      linkConfig.Unmanaged = true;
    };
  };

  # Wait for network to be online
  systemd.services.systemd-networkd-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online --any" ];
    };
  };
}
