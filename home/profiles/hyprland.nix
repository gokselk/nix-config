# Hyprland desktop environment profile
# Wayland compositor with uwsm session management
{ config, pkgs, lib, ... }:
{
  # Hyprland window manager
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;  # uwsm manages systemd integration

    settings = {
      # Monitor configuration - highrr prefers highest refresh rate, auto scale for 4K
      monitor = [ ",highrr,auto,auto" ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee) rgba(cba6f7ee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
      };

      # Input configuration
      input = {
        kb_layout = "us,tr";
        kb_options = "grp:win_space_toggle";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      # Decoration (rounded corners, blur, shadows)
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Key bindings
      "$mod" = "SUPER";
      bind = [
        # Application launchers
        "$mod, Return, exec, ghostty"
        "$mod, D, exec, rofi -show drun"
        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, F, fullscreen,"
        "$mod, L, exec, hyprlock"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshots (with satty annotation)
        ", Print, exec, grim -g \"$(slurp)\" - | satty -f -"
        "SHIFT, Print, exec, grim - | satty -f -"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Autostart
      exec-once = [
        "waybar"
        "mako"
        "hypridle"
      ];

      # Environment variables for Wayland
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "MOZ_ENABLE_WAYLAND,1"
      ];
    };
  };

  # Terminal: ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 11;
      window-padding-x = 10;
      window-padding-y = 10;
    };
  };

  # Catppuccin theming
  catppuccin = {
    flavor = "mocha";
    accent = "blue";
    ghostty.enable = true;
    gtk.enable = true;
    gtk.icon.enable = true;
    kvantum.enable = true;
  };

  # GTK settings
  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 11;
    };
  };

  # Qt theming (match GTK)
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Application launcher: rofi (wayland)
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1e1e2e";
        fg = mkLiteral "#cdd6f4";
        accent = mkLiteral "#89b4fa";
        urgent = mkLiteral "#f38ba8";
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
      };
      window = {
        width = mkLiteral "600px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "10px";
      };
      inputbar = {
        padding = mkLiteral "10px";
        children = map mkLiteral [ "prompt" "entry" ];
      };
      prompt = {
        padding = mkLiteral "0 10px 0 0";
      };
      entry = {
        placeholder = "Search...";
      };
      listview = {
        lines = 8;
        padding = mkLiteral "10px";
      };
      element = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "5px";
      };
      "element selected" = {
        background-color = mkLiteral "@accent";
        text-color = mkLiteral "@bg";
      };
    };
  };

  # Status bar: waybar
  programs.waybar = {
    enable = true;
    systemd.enable = false;  # Started by Hyprland exec-once
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

  # Wayland utilities
  home.packages = with pkgs; [
    # Screenshot tools
    grim
    slurp
    satty

    # Clipboard
    wl-clipboard
    cliphist

    # File manager
    nautilus

    # Audio control
    pavucontrol
    pamixer

    # Brightness control
    brightnessctl

    # Misc Wayland tools
    wlr-randr
    wev

    # Browser
    brave

    # Editor
    vscode-fhs

    # Media
    vlc
    spotify

    # Communication
    vesktop
    telegram-desktop

    # Documents
    typst
    typst-lsp

    # Productivity
    obsidian

    # Screen recording/streaming
    obs-studio

    # Media streaming
    stremio

    # Fonts
    corefonts      # Arial, Times New Roman, Courier New, etc.
    vistafonts     # Calibri, Cambria, Consolas, etc.
    inter          # Modern UI font

    # Theming
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    catppuccin-kvantum

    # Utilities
    qbittorrent
    bitwarden-desktop

    # KDE apps
    kdePackages.okular      # PDF/document viewer
    kdePackages.dolphin     # File manager
    kdePackages.gwenview    # Image viewer
    kdePackages.ark         # Archive manager
  ];

  # Desktop environment variables
  home.sessionVariables = {
    BROWSER = "brave";
    TERMINAL = "ghostty";
  };

  # Cursor theme
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  # XDG user directories
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # mpv with gpu-next, vulkan, hq profile
  programs.mpv = {
    enable = true;
    config = {
      profile = "high-quality";
      vo = "gpu-next";
      gpu-api = "vulkan";
      hwdec = "vulkan";
    };
  };

  # Brave debloat policies
  xdg.configFile."BraveSoftware/Brave-Browser/policies/managed/policies.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveNewsEnabled = false;
    BraveLeoAssistantEnabled = false;
    BraveVPNDisabled = true;
    MetricsReportingEnabled = false;
  };
}
