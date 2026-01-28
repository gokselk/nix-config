# Hardware configuration for MiniPC
# AMD Ryzen 6800H (Rembrandt APU)
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Kernel modules for boot
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];

  # AMD KVM virtualization support
  boot.kernelModules = [ "kvm-amd" ];

  # AMD CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # AMD GPU support (Rembrandt has RDNA2 iGPU)
  hardware.amdgpu.initrd.enable = true;

  # AMD Seamless Boot - avoid screen going black during boot (DCN 3.0+/RDNA2)
  boot.kernelParams = [ "amdgpu.seamless=1" ];

  # Enable all redistributable firmware
  hardware.enableRedistributableFirmware = true;

  # Enable fstrim for SSD (in addition to ZFS trim)
  services.fstrim.enable = true;
}
