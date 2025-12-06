# SOPS-nix secrets management
{ config, lib, pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;

    # Use SSH host key directly - no separate key deployment needed
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # Secrets defined here (uncomment when secrets.yaml exists)
    # secrets = {
    #   "tailscale/authkey" = {};
    # };
  };

  # Ensure ed25519 host key exists
  services.openssh.hostKeys = [
    {
      path = "/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];
}
