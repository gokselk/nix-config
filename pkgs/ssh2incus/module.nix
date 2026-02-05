{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ssh2incus;
in
{
  options.services.ssh2incus = {
    enable = lib.mkEnableOption "ssh2incus SSH server for Incus";

    port = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      description = "Port to listen on";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall port";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--password-auth" "--debug" ];
      description = "Extra arguments to pass to ssh2incus";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ssh2incus = {
      description = "SSH server for Incus instances";
      after = [ "network.target" "incus.service" ];
      requires = [ "incus.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils pkgs.shadow ];

      serviceConfig = {
        ExecStart = "${pkgs.ssh2incus}/bin/ssh2incus -p ${toString cfg.port} -s /var/lib/incus/unix.socket ${lib.escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "3s";
        SupplementaryGroups = [ "incus-admin" ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
