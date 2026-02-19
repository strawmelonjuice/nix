{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = {
    home.packages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.rbw
      pkgs.curl
      pkgs.wtype
      pkgs.pinentry-tty
    ];

    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = [ "gnome" ];
    };
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = false;
      settings = {
        wallpaper = {
          enabled = true;
          path = "/home/mar/.local/share/wallpapers/current_wallpaper.png";
        };
        bar = {
          position = "top";
          margins = {
            top = 10;
            left = 15;
            right = 15;
          };
          capsuleOpacity = 1;
          backgroundOpacity = 0.2;
          useSeparateOpacity = true;
          floating = true;
          density = "default";
          widgets = {
            left = [
              {
                id = "Workspace";
              }
              # {
              #   id = "Launcher";
              # }
              {
                id = "ActiveWindow";
              }
            ];
            center = [
              {
                id = "Clock";
              }
              {
                id = "plugin:kde-connect";
              }
            ];
            right = [
              {
                id = "MediaMini";
              }
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              # {
              #   id = "SystemMonitor";
              # }
              {
                id = "plugin:catwalk";
              }
              {
                id = "Battery";
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "NightLight";
              }
            ];
          };
        };
        controlCenter.enabled = false;
        dock.enabled = false;
        appLauncher = {
          enableClipboardHistory = true;
        };
        ui = {
          fontDefault = "Atkinson Hyperlegible Next 12";
          location = {
            name = "Eindhoven";
            weatherEnabled = true;
            weatherShowEffects = true;
            useFahrenheit = false;
            use12hourFormat = false;
            showWeekNumberInCalendar = false;
            showCalendarEvents = true;
            showCalendarWeather = true;
            analogClockInCalendar = false;
            firstDayOfWeek = -1;
            hideWeatherTimezone = false;
            hideWeatherCityName = false;
          };

        };
        nightLight = {
          enabled = true;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };
        colorSchemes.useWallpaperColors = false;
        colorSchemes.predefinedScheme = "Noctalia (default)";
        templates = {
          gtk = true;
          qt = true;
          niri = true;
        };
        sessionMenu = {
          enable = false;
        };
        plugins = {
          autoUpdate = true;
        };

      };
      pluginSettings = {
        catwalk = {
          minimumThreshold = 25;
          hideBackground = true;
        };
      };
      plugins = {

        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
          {
            enabled = true;
            name = "Rukh Debug unofficial noctalia plugin repository";
            url = "https://github.com/rukh-debug/noctalia-unofficial-plugins";
          }
        ];
        states = {
          catwalk = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          kde-connect = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          niri-overview-launcher = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          bitwarden-rbw-noctalia-launcher = {
            enabled = true;
            sourceUrl = "https://github.com/rukh-debug/noctalia-unofficial-plugins";

          };
        };
        version = 2;
      };

    };

    home.activation.setupNoctaliaDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.xdg.configHome}/gtk-4.0
      mkdir -p ${config.xdg.configHome}/gtk-3.0
      touch ${config.xdg.configHome}/gtk-4.0/gtk.css
      touch ${config.xdg.configHome}/gtk-3.0/gtk.css
    '';
    xdg.configFile."noctalia/colors.json".text = builtins.toJSON {
      "mSurface" = "#e06666";
      "mOnSurface" = "#000000";
      "mPrimary" = "#f4cccc";
      "mOnPrimary" = "#000000";
      "mSecondary" = "#fa8071";
      "mOutline" = "#ff4d47";

      "mSurfaceVariant" = "#e06666";
      "mOnSurfaceVariant" = "#000000";
      "mTertiary" = "#f4cccc";
      "mOnTertiary" = "#000000";
      "mError" = "#ff0000";
      "mOnError" = "#ffffff";
      "mShadow" = "#000000";
      "mHover" = "#f4cccc";
      "mOnHover" = "#000000";
    };
  };

}
