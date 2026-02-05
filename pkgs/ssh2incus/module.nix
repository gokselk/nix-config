self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ssh2incus;

  settingsFormat = pkgs.formats.yaml { };

  configAttrs = {
    listen = ":${toString cfg.port}";
    socket = cfg.socket;
  } // cfg.settings;

  configFile = settingsFormat.generate "config.yaml" configAttrs;
in
{
  options.services.ssh2incus = {
    enable = lib.mkEnableOption "ssh2incus SSH server for Incus instances";

    package = lib.mkPackageOption self.packages.${pkgs.stdenv.hostPlatform.system} "ssh2incus" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      description = "Port for the SSH server to listen on.";
    };

    socket = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/incus/unix.socket";
      description = "Path to the Incus Unix socket.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open the firewall port for ssh2incus.";
    };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "User to run the ssh2incus service as. Runs as root when null.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf settingsFormat.type;
      default = { };
      description = ''
        Additional settings for ssh2incus config.yaml.
        Keys must be kebab-case matching upstream configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."ssh2incus/config.yaml".source = configFile;

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.ssh2incus = {
      description = "SSH server for Incus instances";
      after = [
        "network.target"
        "incus.service"
      ];
      requires = [ "incus.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ pkgs.coreutils ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        WorkingDirectory = "/etc/ssh2incus";
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = "3s";
        SupplementaryGroups = [ "incus-admin" ];
      } // lib.optionalAttrs (cfg.user != null) { User = cfg.user; };
    };
  };
}
