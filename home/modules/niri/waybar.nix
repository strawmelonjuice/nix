{
  pkgs,
  ...
}:

{
  config = {
    home.packages = [
      pkgs.waybar
      pkgs.swaybg
      pkgs.wlsunset
      pkgs.networkmanagerapplet
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
          margin = "10 15 0 15";
          spacing = 8;

          modules-left = [
            "niri/workspaces"
            "niri/window"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "tray"
            "pulseaudio"
            "backlight"
            "battery"
            "custom/power"
          ];

          "niri/workspaces" = {
            format = "{name}";
            all-outputs = true;
          };

          "clock" = {
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d, %Y (%R)}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          "pulseaudio" = {
            format = "{icon}  {volume}%";
            format-muted = "󰝟";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "pavucontrol";
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };

          "custom/power" = {
            format = " 󰐥 ";
            on-click = "wlogout";
          };
        }
      ];

      style = ''
                                        * {
                                            font-family: "Font Awesome 6 Free", "Hermit", "Roboto";
                                            font-size: 13px;
                                	    color: #e8a0a5;
                                            border: none;
                                            border-radius: 0;
                                        }

                                        window#waybar {
                                            background: transparent;
                                        }

                                        .modules-left, .modules-center, .modules-right {
                                            background: rgba(30, 30, 35, 0.8); 
                                            border-radius: 12px;
                                            padding: 2px 10px;
                                            border: 1px solid rgba(255, 255, 255, 0.1);
                                        }

                                        #workspaces button {
                			    border-radius: 12px;
                        	            border: dotted 2px #bfa6a8;
                                            padding: 0 5px;
        				    margin: 0 5px;
                                            color: #f1c4c7; 
                                        }

                                        #workspaces button.focused {
                        	            border: dotted 2px #1e8b44;
                                            color: #1e8b44;
                                            font-weight: bold;
                                        }

                                        #clock {
                                            color: #e8a0a5;
                                        }

                                        #battery.critical {
                                            color: #cf6679;
                                            animation: blink 0.5s linear infinite alternate;
                                        }

                                        @keyframes blink {
                                            to { color: white; }
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
