# Kubernetes tools
{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    k9s
    stern # Multi-pod log tailing
    kubectx # Context/namespace switching
  ];
}
