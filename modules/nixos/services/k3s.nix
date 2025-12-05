# K3s Kubernetes configuration
{ config, lib, pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = toString [
      "--disable=traefik"              # Use your own ingress controller
      "--write-kubeconfig-mode=644"    # Make kubeconfig readable
      "--flannel-iface=vmbr0"          # Use bridge interface for flannel
      "--node-ip=192.168.1.200"        # Explicit node IP for bridge networking
    ];
  };

  # Required firewall ports for Kubernetes
  networking.firewall.allowedTCPPorts = [
    6443  # Kubernetes API server
    10250 # Kubelet metrics
  ];

  # Kubernetes requires swap to be disabled
  swapDevices = lib.mkForce [];

  # Kubernetes tools
  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
    k9s        # Terminal UI for Kubernetes
    stern      # Multi-pod log tailing
  ];

  # Set KUBECONFIG for convenience
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
}
