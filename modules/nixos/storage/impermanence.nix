{ lib, ... }:
{
  # /persist is the source of bind mounts and /var holds many bind-mount
  # targets — both must be mounted before activation sets up the binds.
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/log"
      "/var/lib/tailscale"
      "/var/lib/incus"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  # Point sshd at /persist directly instead of bind-mounting /etc/ssh.
  # Binding the directory hides the nix-managed /etc/ssh/sshd_config; reading
  # keys from /persist preserves both sshd_config and key persistence.
  services.openssh.hostKeys = [
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];

  sops.age.sshKeyPaths = lib.mkForce [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];
}
