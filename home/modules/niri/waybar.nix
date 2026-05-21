{
  pkgs,
  ...
}:

{
  config = {
    home.packages = [
      pkgs.waybar
      pkgs.waybar-mpris
      pkgs.awww
      pkgs.wlsunset
      # pkgs.networkmanagerapplet
      pkgs.pavucontrol
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwalletmanager
      pkgs.kdePackages.ksshaskpass
    ];

    services.wlsunset = {
      enable = true;
      latitude = "51.4";
      longitude = "5.4";
      temperature.night = 4000;
    };

    programs.waybar = {
      enable = true;
      systemd.enable = false;
      settings = [
        {
          layer = "top";
          position = "top";
          height = 30;
          margin = "5 15 0 15";
          spacing = 5;

          modules-left = [
            "niri/workspaces"
            "niri/window"
          ];
          modules-center = [
            "clock"
            "custom/media"
          ];
          modules-right = [
            "tray"
            "custom/osktoggle"
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "battery"
            "custom/exit"
          ];

          "niri/workspaces" = {
            rewrite = {
              "(.*) - Discord" = "# Discord: $1";
              "Element \\| (.*)" = "# Element: $1";
              "(.*) - ArmCord" = "# Discord: $1";
              "Revolt" = "# Revolt";
              "(.*) — LibreWolf" = "$1";
              "(.*) — Mozilla Firefox" = "$1";
              "(.*) — Zen Browser" = "$1";
              "(.*) - Chromium" = "$1";
              "(.*) - Vivaldi" = "$1";
              "Spotify (.*)" = "Spotify";
              "(.*) - Tidal" = "Tidal";
              "(.*) - TIDAL" = "Tidal";
              "(.*) - Obsidian (.*)" = "Obsidian";
            };
            separate-outputs = true;
          };

          "custom/osktoggle" = {
            format = "   ";
            on-click = "~/.config/niri/scripts/osk.sh";
            tooltip-format = "Toggle the on-screen keyboard (restarts the keyboard if needed.)";
          };

          "custom/media" = {
            return-type = "json";
            exec = ''
              waybar-mpris --position --autofocus --play "" --pause "" --order "SYMBOL:TITLE:POSITION"
              	    '';
            on-click = "waybar-mpris --send toggle";
            # This option will switch between players on right click.
            on-click-right = "waybar-mpris --send player-next";
            # The options below will switch the selected player on scroll
            # on-scroll-up = "waybar-mpris --send player-next";
            # on-scroll-down = "waybar-mpris --send player-prev";
            # The options below will go to next/previous track on scroll
            on-scroll-up = "waybar-mpris --send next";
            on-scroll-down = "waybar-mpris --send prev";
            escape = true;
          };
          "custom/exit" = {
            format = "";
            tooltip-format = "Powermenu";
            on-click = "wlogout";
            tooltip = false;
          };

          "keyboard-state" = {
            numlock = true;
            capslock = true;
            format = "{name} {icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };

          tray = {
            spacing = 10;
          };

          clock = {
            timezone = "Europe/Amsterdam";
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d, %Y (%R)}";
          };

          cpu = {
            format = " {usage}% ";
            on-click = "wezterm -e htop";
          };

          memory = {
            format = " {}% ";
            on-click = "wezterm -e btop";
          };

          network = {
            format = "{ifname}";
            format-wifi = " ";
            format-ethernet = "  ";
            format-disconnected = "Not connected";
            tooltip-format = " {ifname} via {gwaddri}";
            tooltip-format-wifi = "   {essid} ({signalStrength}%)";
            tooltip-format-ethernet = "  {ifname} ({ipaddr}/{cidr})";
            tooltip-format-disconnected = "Disconnected";
            max-length = 50;
            on-click = "wezterm -e nmtui connect";
          };

          battery = {
            "states" = {
              "good" = 80;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon} {capacity}%";
            "format-alt" = "{icon}  {time}";
            "format-charging" = "  {capacity}%";
            "format-plugged" = "  {capacity}%";
            "format-full" = "";
            "format-icons" = [
              " "
              " "
              " "
              " "
              " "
            ];
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "{icon}";
            format-muted = "";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                " "
                " "
              ];
            };
            on-click = "pavucontrol";
          };
        }
      ];

      style = ''
        @define-color backgroundlight #6faa88;
        @define-color backgrounddark #f4cccc;
        @define-color workspacesbackground1 #67db98;
        @define-color workspacesbackground2 #f4cccc;
        @define-color workspacesbackground3 #fa8071;
        @define-color bordercolor #f4cccc;
        @define-color textcolor1 #000000;
        @define-color textcolor2 #000000;
        @define-color textcolor3 #f4cccc;
        @define-color iconcolor #9b4457;

        * {
          font-family: Hermit, "Font Awesome 6 Free", FontAwesome, Ubuntu, Arial, sans-serif;
          border: none;
          border-radius: 0px;
        }

        window#waybar {
          background-color: transparent;
          transition-property: background-color;
          transition-duration: 0.5s;
        }

        /* Common module styling */
        #workspaces,
        #window,
        #custom-osktoggle,
        #custom-exit,
        #cpu,
        #memory,
        #disk,
        #keyboard-state,
        #clock,
        #custom-media,
        #pulseaudio,
        #network,
        #bluetooth,
        #battery,
        #tray {
          margin: 3px 2px;
          padding: 2px 8px;
          border-radius: 8px;
          background-color: @backgroundlight;
          color: @textcolor1;
          font-size: 13px;
        }

        /* -----------------------------------------------------
         * Workspaces
         * ----------------------------------------------------- */
        #workspaces {
          background-color: @workspacesbackground3;
          padding: 0px 4px;
        }

        #workspaces button {
          padding: 0px 4px;
          margin: 2px 1px;
          border-radius: 4px;
          color: @textcolor1;
          background: @workspacesbackground1;
          min-width: 20px;
          transition: all 0.2s ease-in-out;
        }

        #workspaces button.active, #workspaces button.focused {
          background: @workspacesbackground2;
          color: @textcolor1;
          border: 1px solid rgb(255,77,77);
          min-width: 30px;
        }

        /* -----------------------------------------------------
         * Window
         * ----------------------------------------------------- */
        #window {
          font-weight: normal;
          font-size: 11px;
        }

        window#waybar.empty #window {
          background-color: transparent;
        }

        /* -----------------------------------------------------
         * Specific Module Overrides
         * ----------------------------------------------------- */
        #pulseaudio {
          background-color: #e06666;
          color: #000000;
        }
        #pulseaudio.muted {
          background-color: #fadfb0;
          color: #ffa07a;
        }

        #battery {
          border: 1px dotted rgb(255,77,77);
        }

        #battery.critical:not(.charging) {
          background-color: #fadfb0;
          color: #ffa07a;
          animation: blink 0.5s linear infinite alternate;
        }

        @keyframes blink {
          to {
            background-color: @backgroundlight;
            color: @textcolor2;
          }
        }

        #tray {
          background-color: rgba(250, 128, 113, 0.3);
          border: 1px dotted rgb(255,77,77);
          padding: 0px 6px;
        }

        #clock {
          font-weight: bold;
        }

        #custom-exit {
          color: @iconcolor;
          padding-right: 12px;
        }

        #cpu, #memory {
          font-size: 10px;
        }

        tooltip {
          border-radius: 10px;
          background-color: @backgroundlight;
          padding: 10px;
        }
        tooltip label {
          color: @textcolor2;
        }
      '';
    };

    home.sessionVariables = {
      SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    };

    home.file.".config/kwalletrc".text = ''
      [Wallet]
      First Use=false
      Enabled=true
      Default Wallet=kdewallet
    '';
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-cosmic ];
      config.common.default = [ "gtk" ];
    };
  };
}
