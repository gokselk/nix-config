{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ssh2incus;

  configFile = pkgs.writeText "ssh2incus-config.yaml" ''
    listen: ":${toString cfg.port}"
    socket: "/var/lib/incus/unix.socket"
    ${lib.optionalString (cfg.settings != { }) (lib.generators.toYAML { } cfg.settings)}
  '';
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

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User to run as (uses their ~/.ssh/authorized_keys for auth)";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        groups = "incus,incus-admin";
        debug = true;
      };
      description = "Additional settings for config.yaml";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."ssh2incus/config.yaml".source = configFile;

    systemd.services.ssh2incus = {
      description = "SSH server for Incus instances";
      after = [ "network.target" "incus.service" ];
      requires = [ "incus.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils ];

      serviceConfig = {
        ExecStart = "${pkgs.ssh2incus}/bin/ssh2incus";
        Restart = "on-failure";
        RestartSec = "3s";
        SupplementaryGroups = [ "incus-admin" ];
        WorkingDirectory = "/etc/ssh2incus";
      } // lib.optionalAttrs (cfg.user != null) {
        User = cfg.user;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
