# SOPS-nix secrets management
{ config, lib, pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;

    age = {
      # Generate dedicated age key (standard sops-nix approach)
      # After rebuild, get public key with: just host-key
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    # Secrets defined here (uncomment when secrets.yaml exists)
    # secrets = {
    #   "tailscale/authkey" = {};
    # };
  };
}
