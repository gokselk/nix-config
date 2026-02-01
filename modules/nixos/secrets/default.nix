# SOPS-nix secrets management
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../secrets/hosts/common/secrets.yaml;

    age = {
      # Use SSH host key converted to age (solves chicken-egg problem)
      # SSH host keys are auto-generated during NixOS installation
      # Get age public key: ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # Define secrets to decrypt
    secrets = {
      "tailscale/authkey" = { };
    };
  };
}
