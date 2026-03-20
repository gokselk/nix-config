# Firewall configuration (firewalld)
{ pkgs, ... }:
{
  # Disable NixOS built-in firewall in favor of firewalld
  networking.firewall.enable = false;

  # Use nftables backend (required by Incus and firewalld)
  networking.nftables.enable = true;

  # Enable firewalld
  services.firewalld = {
    enable = true;

    settings = {
      # Allow Incus to manage its own nftables rules alongside firewalld
      NftablesTableOwner = false;
      LogDenied = "unicast";
    };

    zones = {
      # Default zone: SSH, Tailscale, K3s, ping
      public = {
        forward = true;
        services = [ "ssh" ];
        ports = [
          {
            port = 41641;
            protocol = "udp";
          } # Tailscale
          {
            port = 6443;
            protocol = "tcp";
          } # K3s API
        ];
      };

      # Trusted zone for Incus bridges
      trusted = {
        target = "ACCEPT";
        forward = true;
        interfaces = [
          "incusbr0"
          "vmbr0"
        ];
      };
    };
  };

  # COI needs passwordless firewall-cmd and nft for network isolation
  security.sudo.extraRules = [
    {
      groups = [ "incus-admin" ];
      commands = [
        {
          command = "${pkgs.firewalld}/bin/firewall-cmd";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.nftables}/bin/nft";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
