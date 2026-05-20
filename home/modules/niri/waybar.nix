{
  pkgs,
  ...
}:

{
  config = {
    home.packages = [
      pkgs.waybar
      pkgs.waybar-mpris
      pkgs.swaybg
      pkgs.wlsunset
      # pkgs.networkmanagerapplet
      pkgs.pavucontrol
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwalletmanager
      pkgs.kdePackages.ksshaskpass
    ];

    systemd.user.services.swaybg = {
      Unit.Description = "Swaybg wallpaper daemon";
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i /home/mar/.local/share/wallpapers/current_wallpaper.png -m fill";
        Restart = "always";
      };
    };

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
          height = 20;
          margin = "5 15 0 15";
          spacing = 5;

          modules-left = [
            "niri/workspaces"
            "niri/window"
          ];
          modules-center = [
            "custom/osktoggle"
            "battery"
            "clock"
            "custom/exit"
          ];
          modules-right = [
            "tray"
            "mpd"
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "keyboard-state"
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

            # format = "{name}";
            # all-outputs = true;
            separate-outputs = true;
          };

          "custom/osktoggle" = {
            format = "   ";
            on-click = "~/.config/niri/scripts/osk.sh";
            tooltip-format = "Toggle the on-screen keyboard (restarts the keyboard if needed.)";
          };
          "custom/waybar-mpris" = {
            return-type = "json";
            exec = "waybar-mpris --position --autofocus";
            on-click = "waybar-mpris --send toggle";
            # This option will switch between players on right click.
            on-click-right = "waybar-mpris --send player-next";
            # The options below will switch the selected player on scroll
            # "on-scroll-up"= "waybar-mpris --send player-next";
            # "on-scroll-down"= "waybar-mpris --send player-prev";
            # The options below will go to next/previous track on scroll
            # "on-scroll-up"= "waybar-mpris --send next";
            # "on-scroll-down"= "waybar-mpris --send prev";
            escape = true;
          };

          "custom/exit" = {
            "format" = "";
            "tooltip-format" = "Powermenu";
            "on-click" = "wlogout -b 4";
            "tooltip" = false;
          };
          # Keyboard State
          "keyboard-state" = {
            "numlock" = true;
            "capslock" = true;
            "format" = "{name} {icon}";
            "format-icons" = {
              "locked" = "";
              "unlocked" = "";
            };
          };
          # System tray
          "tray" = {
            # "icon-size"= 21;
            "spacing" = 10;
          };
          # Clock
          clock = {
            timezone = "Europe/Amsterdam";
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d, %Y (%R)}";
          };
          # System
          "custom/system" = {
            "format" = "";
            "tooltip" = false;
          };
          # CPU
          "cpu" = {
            "format" = " {usage}% ";
            "on-click" = "wezterm -e htop";
          };
          # Memory
          "memory" = {
            "format" = " {}% ";
            "on-click" = "wezterm -e btop";
          };
          # Harddisc space used
          "disk" = {
            "interval" = 30;
            "format" = "D {percentage_used}% ";
            "path" = "/";
            "on-click" = "wezterm -e htop";
          };
          "hyprland/language" = {
            "format" = "/ K {short}";
          };
          # Group Hardware
          "group/hardware" = {
            "orientation" = "inherit";
            "drawer" = {
              "transition-duration" = 300;
              "children-class" = "not-memory";
              "transition-left-to-right" = false;
            };
            "modules" = [
              "custom/system"
              "disk"
              "cpu"
              "memory"
            ];
          };
          # Network
          "network" = {
            "format" = "{ifname}";
            "format-wifi" = " ";
            "format-ethernet" = "  ";
            "format-disconnected" = "Not connected";
            "tooltip-format" = " {ifname} via {gwaddri}";
            "tooltip-format-wifi" = "   {essid} ({signalStrength}%)";
            "tooltip-format-ethernet" = "  {ifname} ({ipaddr}/{cidr})";
            "tooltip-format-disconnected" = "Disconnected";
            "max-length" = 50;
            "on-click" = "wezterm -e nmtui connect";
          };
          # Battery
          "battery" = {
            "states" = {
              "good" = 80;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon} {capacity}%";
            "format-alt" = "{icon}  {time}";
            "format-charging" = "  {capacity}%";
            "format-plugged" = "  {capacity}%";
            # "format-good"= " ";
            "format-full" = "";
            "format-icons" = [
              " "
              " "
              " "
              " "
              " "
            ];
          };
          # Pulseaudio
          "pulseaudio" = {
            # "scroll-step"= 1; // %, can be a float
            "format" = "{icon}  {volume}%";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = "{icon}";
            "format-muted" = "";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                " "
                " "
              ];
            };
            "on-click" = "pavucontrol";
          };
          # Bluetooth
          "bluetooth" = {
            "format-disabled" = "";
            "format-off" = "";
            "interval" = 30;
            "on-click" = "blueman-manager";
            "format-no-controller" = "";
          };
          # Other
          "user" = {
            "format" = "{user}";
            "interval" = 60;
            "icon" = false;
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
        @define-color textcolor2  #000000;
        @define-color textcolor3 #f4cccc;
        @define-color iconcolor #9b4457;


        * {
          font-family: Hermit, "Font Awesome 6 Free", FontAwesome, Ubuntu, Arial,
            sans-serif;
          border: none;
          border-radius: 0px;
        }

        window#waybar {
          background-color: transparent;
          /* border-bottom: 3px groove rgb(255,204,255); */
          /* color: #FFFFFF; */
          transition-property: background-color;
          transition-duration: 0.5s;
        }


        #workspaces {
          margin: 5px 6px 6px 3px;
          padding: 0px 1px;
          border-radius: 5px;
          background-color: @workspacesbackground3;
          border: 0px;
          font-weight: bold;
          font-style: normal;
          font-size: 10px;
          color: @textcolor1;
        }

        #workspaces button {
          padding: 8px 0px;
          margin: 4px 3px;
          border-radius: 5px;
          border: 0px;
          min-width: 15px;
          color: @textcolor1;
          transition: all 0.3s ease-in-out;
          background: @workspacesbackground1;
        }

        #workspaces button.active, #workspaces button.focused {
          padding: 0px 0px;
          color: @textcolor1;
          background: @workspacesbackground2;
          border-radius: 15px;
          min-width: 25px;
          transition: all 1.0s ease-in-out;
          border: 2px rgb(255,77,77) solid;
        }

        #workspaces button:hover {
          color: @textcolor1;
          background: @workspacesbackground2;
          border-radius: 6px;
        }


        tooltip {
          border-radius: 10px;
          background-color: @backgroundlight;
          opacity: 0.8;
          padding: 20px;
          margin: 0px;
        }

        tooltip label {
          color: @textcolor2;
        }

        /* -----------------------------------------------------
         * Window
         * ----------------------------------------------------- */

        #window {
          background: @backgroundlight;
          margin: 10px 15px 10px 0px;
          padding: 2px 10px 0px 10px;
          border-radius: 12px;
          color: @textcolor2;
          font-size: 10px;
          font-weight: normal;
        }

        window#waybar.empty #window {
          background-color: transparent;
        }

        /* -----------------------------------------------------
         * Taskbar
         * ----------------------------------------------------- */
        #taskbar, .niri-taskbar {
          background: @backgroundlight;
          margin: 10px 15px 10px 18px;
          padding: 0px;
          border-radius: 5px;
          font-weight: normal;
          font-style: normal;
          border: 3px dotted @backgroundlight;
        }
        #taskbar button, .niri-taskbar button {
          margin: 3px;
          border-radius: 5px;
          padding: 1px 1px 1px 1px;
          border: 1px transparent;
        }

        #taskbar button.unread, .niri-taskbar button {
          border: 2px dotted @textcolor3;
          border-radius: 5px;
          padding: 2px 2px 2px 2px;
        }

        /* -----------------------------------------------------
         * Modules
         * ----------------------------------------------------- */

        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }

        .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
        }

        /* -----------------------------------------------------
         * Custom Quicklinks
         * ----------------------------------------------------- */

        #custom-browser,
        #custom-filemanager,
        #network,
        #pulseaudio,
        #battery,
        #clock {
          margin-right: 20px;
          font-weight: bold;
          color: @iconcolor;
          padding: 4px 10px 2px 10px;
          font-size: 16px;
        }

        #custom-osktoggle {
          border-radius: 5px;
          font-size: 15px;
          padding: 4px;
          background-color: @backgroundlight;
          color: @textcolor1;
          margin: 10px 20px 10px 20px;
          border-radius: 5px;
          border: 0px;
          font-weight: bold;
          font-style: normal;
        }


        #custom-exit {
          margin: 10px 20px 10px 10px;
          padding: 5px 10px 5px 10px;
          /* Add a little extra padding to the right. to make it look more centered. */
          padding-right: 15px;
          font-size: 15px;
          color: @iconcolor;
          border-radius: 5px;
          background-color: @backgroundlight;
        }


        #disk,
        #memory,
        #cpu,
        #language {
          margin: 10px;
          padding: 10px;
          font-size: 8px;
          color: #000000;
          border-radius: 5px;
          background-color: @backgroundlight;
        }
        /* glue cpu and memory together 
        # #cpu {
        #   margin-right: 0px;
        #   border-radius: 5px 0px 0px 5px;
        #   padding: 0px 10px 0px 10px;
        # }
        # #memory {
        #   margin-left: 0px;
        #   border-radius: 0px 5px 5px 0px;
        #   padding: 0px 10px 0px 10px;
        # }
        */
        #keyboard-state {
          background-color: @backgroundlight;
          font-size: 12px;
          color: @textcolor2;
          border-radius: 5px;
          margin: 10px 10px 10px 0px;
        }

        #language {
          margin-right: 10px;
        }

        /* -----------------------------------------------------
         * Clock
         * ----------------------------------------------------- */

        #clock {
          background-color: @backgroundlight;
          font-size: 16px;
          color: @textcolor1;
          border-radius: 5px;
          margin: 10px 7px 10px 0px;
        }

        /* -----------------------------------------------------
         * Pulseaudio
         * ----------------------------------------------------- */

        #pulseaudio {
          font-size: 16px;
          border-radius: 5px;
          margin: 10px 10px 10px 0px;
          background-color: #e06666;
          color: #000000;

        }

        #pulseaudio.muted {
          color: #ffa07a;
          background-color: #fadfb0;
          }

        /* -----------------------------------------------------
         * Network
         * ----------------------------------------------------- */

        #network {
          background-color: @backgroundlight;
          font-size: 16px;
          color: @textcolor2;
          border-radius: 5px;
          margin: 10px 10px 10px 0px;
        }

        #network.ethernet {
          background-color: @backgroundlight;
          color: @textcolor2;
        }

        #network.wifi {
          background-color: @backgroundlight;
          color: @textcolor2;
        }

        /* -----------------------------------------------------
         * Bluetooth
         * ----------------------------------------------------- */

        #bluetooth,
        #bluetooth.on,
        #bluetooth.connected {
          background-color: @backgroundlight;
          font-size: 16px;
          color: @textcolor2;
          border-radius: 5px;
          margin: 10px 15px 10px 0px;
        }

        #bluetooth.off {
          background-color: transparent;
          padding: 0px;
          margin: 0px;
        }

        /* -----------------------------------------------------
         * Battery
         * ----------------------------------------------------- */

        #battery {
          background-color: @backgroundlight;
          font-size: 16px;
          color: @textcolor2;
          border: 2px rgb(255,77,77) dotted;
          border-radius: 5px;
          margin: 10px 15px 10px 0px;
        }

        #battery.charging,
        #battery.plugged {
          color: @textcolor2;
          background-color: @backgroundlight;
        }

        @keyframes blink {
          to {
            background-color: @backgroundlight;
            color: @textcolor2;
          }
        }

        #battery.warning:not(.charging) {
          background-color: #f1c40f;
          color: @textcolor3;
        }

        #battery.full {
          color: @textcolor3;
          background-color: #2ecc71;
        }

        #battery.good:not(.charging) {
          background-color: #3498db;
          color: @textcolor3;
        }

        #battery.critical:not(.charging) {
          color: #ffa07a;
          background-color: #fadfb0;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        /* -----------------------------------------------------
         * Tray
         * ----------------------------------------------------- */

        #tray {
          background-color: rgba(250, 128, 113, 0.3);
          border-radius: 5px;
          border: 2px rgb(255,77,77) dotted;
          padding: 4px;
          margin: 10px 15px 10px 0px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
        }

        /* -----------------------------------------------------
         * Other
         * ----------------------------------------------------- */

        label:focus {
          background-color: #000000;
        }

        #backlight {
          background-color: #90b1b1;
        }

        #network {
          background-color: #2980b9;
        }

        #network.disconnected {
          color: #ffa07a;
          background-color: #fadfb0;
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
