# ZFS disk configuration for hl-node01
# Uses disko for declarative disk partitioning
# Layout based on Graham Christensen's ZFS dataset philosophy
{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Update this to match your actual disk device
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # EFI System Partition
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # ZFS partition (remainder of disk)
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        # Single disk, no RAID
        mode = "";

        # Pool-level options
        options = {
          ashift = "12";       # 4K sector alignment
          autotrim = "on";     # SSD TRIM support
        };

        # Root filesystem options (inherited by datasets)
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          dnodesize = "auto";
          normalization = "formD";
          relatime = "on";
          "com.sun:auto-snapshot" = "false";
        };

        mountpoint = null;

        datasets = {
          # LOCAL: Not backed up (can be rebuilt from Nix)
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              atime = "off";
              "com.sun:auto-snapshot" = "false";
            };
          };

          # SYSTEM: Core OS data
          "system" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "system/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options."com.sun:auto-snapshot" = "true";
            # Create blank snapshot for potential impermanence setup
            postCreateHook = "zfs snapshot rpool/system/root@blank";
          };
          "system/var" = {
            type = "zfs_fs";
            mountpoint = "/var";
            options."com.sun:auto-snapshot" = "true";
          };

          # USER: User data (most important for backups)
          "user" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "user/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
          };

          # PERSIST: Persistent state that should survive rebuilds
          "persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "true";
          };

          # INCUS: Dedicated dataset for Incus containers/VMs
          "incus" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              "com.sun:auto-snapshot" = "false";
            };
          };

          # RESERVED: Emergency disk space buffer
          "reserved" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              refreservation = "10G";
            };
          };
        };
      };
    };
  };
}
