# K3s lightweight Kubernetes (single-node dev cluster)
{ pkgs, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable=traefik" # Install ingress yourself via Helm/Flux
      "--disable=servicelb" # Use MetalLB or similar instead
    ];
  };

  # Firewall: K3s API server
  networking.firewall.allowedTCPPorts = [
    6443 # Kubernetes API
  ];

  # CLI tools
  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
    k9s
  ];
}
