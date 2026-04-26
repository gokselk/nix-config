{ lib, ... }:
{
  # /persist is the source of bind mounts and /var holds many bind-mount
  # targets — both must be mounted before activation sets up the binds.
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var".neededForBoot = true;

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/ssh"
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

  # Read sops host age key directly from /persist to avoid any timing
  # dependency on etc-ssh.mount being up before sops decryption runs.
  sops.age.sshKeyPaths = lib.mkForce [
    "/persist/etc/ssh/ssh_host_ed25519_key"
  ];
}
