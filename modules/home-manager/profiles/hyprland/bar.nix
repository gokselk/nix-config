# Waybar configuration
# Status bar for Hyprland
{ config, pkgs, lib, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;  # Managed by uwsm/systemd
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "hyprland/language" "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
        };

        "hyprland/language" = {
          format = "{}";
          format-en = "US";
          format-tr = "TR";
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        cpu.format = " {usage}%";
        memory.format = " {}%";

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = " ";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " ";
          format-icons.default = [ "" "" "" ];
          on-click = "pavucontrol";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        tray.spacing = 10;
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        border-bottom: 2px solid #89b4fa;
      }

      #workspaces button {
        padding: 0 5px;
        color: #cdd6f4;
        border-radius: 5px;
      }

      #workspaces button.active {
        background-color: #89b4fa;
        color: #1e1e2e;
      }

      #language {
        padding: 0 10px;
        background-color: #cba6f7;
        color: #1e1e2e;
        border-radius: 5px;
        margin: 4px 4px;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 0 4px;
      }
    '';
  };
}
