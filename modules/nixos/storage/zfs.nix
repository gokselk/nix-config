# ZFS configuration module
{ config, lib, pkgs, ... }:
let
  # Find the latest ZFS-compatible kernel
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;

  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  # Boot support for ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  # Use the latest ZFS-compatible kernel
  # Note: This might change as kernels are added or removed
  boot.kernelPackages = latestKernelPackage;

  # Automatic snapshots with zfs-auto-snapshot
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 4;    # Keep 4 x 15-minute snapshots
    hourly = 24;     # Keep 24 hourly snapshots
    daily = 7;       # Keep 7 daily snapshots
    weekly = 4;      # Keep 4 weekly snapshots
    monthly = 12;    # Keep 12 monthly snapshots
  };

  # Automatic scrub for data integrity
  services.zfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  # Enable TRIM for SSDs
  services.zfs.trim.enable = true;

  # ZFS utilities
  environment.systemPackages = with pkgs; [
    zfs
  ];
}
