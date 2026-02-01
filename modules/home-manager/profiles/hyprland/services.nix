# Desktop services
# Notifications (mako), screen lock (hyprlock), idle daemon (hypridle), wallpaper (hyprpaper)
{ config, pkgs, lib, ... }:
{
  # Wallpaper: hyprpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${pkgs.hyprland}/share/hyprland/wall0.png" ];
      wallpaper = [ ",${pkgs.hyprland}/share/hyprland/wall0.png" ];
    };
  };
  # Notifications: mako
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 10";
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 10;
      border-size = 2;
      default-timeout = 5000;
      layer = "overlay";
    };
  };

  # Screen lock: hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 5;
      };
      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
      input-field = [{
        monitor = "";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        outer_color = "rgb(89, 180, 250)";
        inner_color = "rgb(30, 30, 46)";
        font_color = "rgb(205, 214, 244)";
        fade_on_empty = true;
        placeholder_text = "<i>Enter Password...</i>";
        hide_input = false;
      }];
    };
  };

  # Idle daemon: hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;  # 5 minutes
          on-timeout = "hyprlock";
        }
        {
          timeout = 600;  # 10 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
