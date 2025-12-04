# Incus virtualization configuration
{ config, lib, pkgs, ... }:
{
  virtualisation.incus = {
    enable = true;

    # Declarative preseed configuration
    preseed = {
      networks = [
        # NAT network - isolated, 10.10.10.x range
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.10.10.1/24";
            "ipv4.nat" = "true";
            "ipv6.address" = "none";
          };
        }
        # Bridged network - direct LAN access via vmbr0
        {
          name = "lan";
          type = "physical";
          config = {
            parent = "vmbr0";
          };
        }
      ];

      storage_pools = [
        {
          name = "default";
          driver = "zfs";
          config = {
            # Use dedicated ZFS dataset
            "source" = "rpool/incus";
          };
        }
      ];

      profiles = [
        # Default profile: NAT network (isolated) + storage
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "20GiB";
              type = "disk";
            };
          };
        }
        # Bridged profile: direct LAN access (use with default for storage)
        # Usage: incus launch image name --profile default --profile bridged
        {
          name = "bridged";
          devices = {
            eth0 = {
              name = "eth0";
              nictype = "bridged";
              parent = "vmbr0";
              type = "nic";
            };
          };
        }
      ];
    };
  };

  # Required for Incus networking
  networking.nftables.enable = true;

  # Firewall rules for bridges
  networking.firewall.trustedInterfaces = [ "incusbr0" "vmbr0" ];

  # Incus CLI
  environment.systemPackages = [ pkgs.incus ];
}
