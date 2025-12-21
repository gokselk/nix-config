# K3s Kubernetes configuration
{ lib, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = toString [
      "--disable=traefik"              # Use your own ingress controller
      "--write-kubeconfig-mode=644"    # Make kubeconfig readable
    ];
  };

  # Required firewall ports for Kubernetes
  networking.firewall.allowedTCPPorts = [
    6443  # Kubernetes API server
    10250 # Kubelet metrics
  ];

  # Kubernetes requires swap to be disabled
  swapDevices = lib.mkForce [];

  # CLI tools (kubectl, k9s, stern, helm) are in home-manager
  # See: home/profiles/development/kubernetes.nix

  # Set KUBECONFIG for convenience
  environment.variables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
}
