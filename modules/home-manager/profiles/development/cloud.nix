# Cloud and infrastructure tools
{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # Infrastructure as Code
    opentofu # Open source Terraform fork
    ansible

    # Cloud CLIs
    awscli2
    google-cloud-sdk
  ];
}
