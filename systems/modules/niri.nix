{
  lib,
  pkgs,
  config,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    ./gdm.nix
  ];
  home-manager.users.mar = {
    imports = [
      ../../home-manager/configurations/workstation.nix
      inputs.niri.homeModules.niri
    ];
    # programs.plasma.krunner = {
    #   enable = true;
    #   position = "center";
    # };
    home.packages = with pkgs; [
      waybar
      waybar-mpris
      wlsunset
      # networkmanagerapplet
      pavucontrol
      kdePackages.ksshaskpass

      wev
      kdePackages.krunner
      # Emoji's in KDE Runner
      emoji-runner
      kdePackages.kdeconnect-kde
      kdePackages.qttools
      gnome-console
      wl-mirror
      pavucontrol
      btop
      wofi
      hyprlock
      libnotify
      wireplumber
      brightnessctl
      cliphist
      playerctl
      killall
      wvkbd
      blueman
      anyrun
    ];

    services.fnott = {
      enable = true;
      settings.main = {
        anchor = "bottom-right";
        default-timeout = 15;
      };
    };
    # systemd.user.services.fnott = {
    #   Unit = {
    #     Requisite = [ "niri.service" ];
    #     After = [ "niri.service" ];
    #   };
    # };

    xdg.configFile."niri/scripts/osk.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash
        # Relaunch the touch keyboard if it crashed

        PID=$(pidof wvkbd-mobintl)

        if [ -z "$PID" ]; then
          wvkbd-mobintl -L 300 --bg e06666 --fg f4cccc --fg-sp fa8071 --text 000000 --text-sp 000000 --press ff4d47 --press-sp ff0000 --alpha 200
        else
          echo $line >/dev/null
          # Its running, so send it a signal to toggle it up
          kill -34 "$PID"
        fi
      '';
      executable = true;
    };
    xdg.configFile."niri/scripts/overview-runner.sh" = {
      text = ''
              #!/run/current-system/sw/bin/bash
              overviewstatus="$(niri msg overview-state)"
              if [[ $overviewstatus == *"is close"* ]]; then
                niri msg action open-overview
              else
                niri msg action close-overview
        	      ${pkgs.kdePackages.krunner}/bin/krunner &
              fi
      '';
      executable = true;
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        screenshot-path = "${config.home-manager.users.mar.xdg.userDirs.pictures}/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
        input = {
          keyboard = {
            xkb.layout = "us(altgr-intl)";
            numlock = false;
          };
          touchpad = {
            tap = true;
            natural-scroll = true;
            disabled-on-external-mouse = true;
          };
          mouse.accel-speed = 1.0;
          focus-follows-mouse.max-scroll-amount = "15%";
        };

        layer-rules = [
          {
            matches = [
              { namespace = "waybar"; }
            ];
            place-within-backdrop = true;
          }
        ];

        hotkey-overlay = {
          skip-at-startup = true;
        };
        environment = {
          GTK_IM_MODULE = "ibus";
          QT_IM_MODULE = "ibus";
          XMODIFIERS = "@im=ibus";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };

        layout = {
          default-column-display = "tabbed";
          tab-indicator = {
            hide-when-single-tab = true;
          };
          empty-workspace-above-first = true;
          gaps = 6;
          center-focused-column = "never";
          always-center-single-column = true;

          preset-column-widths = [
            { proportion = 0.25; }
            { proportion = 0.5; }
            { proportion = 0.75; }
            { proportion = 1.0; }
          ];
          preset-window-heights = [
            { proportion = 0.4; }
            { proportion = 0.74; }
            { proportion = 1.0; }
          ];
          default-column-width.proportion = 0.75;
          border.enable = false;
          focus-ring = {
            enable = true;
            width = 4;
            active.color = "#85aaa0";
            inactive.color = "#4a4442";
            urgent.color = "#1e8b44";
          };
          shadow = {
            enable = true;
            softness = 30;
            spread = 5;
            offset = {
              x = 2;
              y = 5;
            };
            color = "#0007";
          };
          struts = {
            left = 1;
            right = 1;
          };
        };
        # Startup spawns!
        spawn-at-startup = [
          {
            command = [
              "dbus-update-activation-environment"
              "--systemd"
              "DISPLAY"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP"
              "NIXOS_OZONE_WL"
            ];
          }
          {
            command = [
              "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
            ];
          }
          { command = [ "blueman-applet" ]; }
          { command = [ "blueman-tray" ]; }
          {
            command = [
              "systemctl"
              "--user"
              "restart"
              "wallpaper-switcher.service"
            ];
          }
          { command = [ "waybar" ]; }
          { command = [ "anyrun daemon" ]; }
          { command = [ "vesktop" ]; }
          { command = [ "fluffychat" ]; }
          { command = [ "feishin" ]; }
          # { command = [ "thunderbird" ]; }
          {
            command = [
              "wl-paste"
              "--type"
              "text"
              "--watch"
              "cliphist"
              "store"
            ];
          }
          {
            command = [
              "wl-paste"
              "--type"
              "image"
              "--watch"
              "cliphist"
              "store"
            ];
          }
          # { command = [ "kdeconnectd" ]; }
          {
            sh = "sleep 5s; niri msg action focus-workspace 1 && systemctl --user start wallpaper-switcher; krunner";
          }
        ];

        prefer-no-csd = true;

        workspaces = {
          # Dedicated to conversation
          "2" = {
            name = "";
          };
          # Dedicated to music listening
          "3" = {
            name = "🎶";
          };
        };

        window-rules = [
          {
            matches = [
              { app-id = "Spotify"; }
            ];

            open-maximized = true;
          }
          {
            matches = [
              { app-id = "^org\\.wezfurlong\\.wezterm$"; }
            ];
            default-column-width = { };
          }
          {
            matches = [
              {
                app-id = "Chromium-browser";
                title = "(.*) • (.*)";
              }
              { title = "^Picture-in-Picture$"; }
              { app-id = "org.gnome.Characters"; }
              { app-id = "org.gnome.Calculator"; }
            ];
            open-floating = true;
          }
          {
            matches = [
              {
                title = "heylogin";
                app-id = "^-kghbmcgihmefcbjlfiafjcigdcbmecbf__globalSearch.html$";
              }

            ];
            block-out-from = "screen-capture";
            open-floating = true;
            opacity = 0.95;
            default-column-width = {
              fixed = 100;
            };
            default-window-height = {
              fixed = 100;
            };

          }
          {
            matches = [
              { app-id = "citrine"; }
              { app-id = "feishin"; }
              { app-id = "Spotify"; }
              { app-id = "org.strawberrymusicplayer.strawberry"; }
              { app-id = "org.gnome.Music"; }
            ];
            open-on-workspace = "🎶";
          }
          {
            matches = [
              { app-id = "app.cinny.in"; }
              { app-id = "cinny"; }
              { app-id = "discord"; }
              { app-id = "vesktop"; }
              { app-id = "pliiebkcmokkgndfalahlmimanmbjlab"; }
              { app-id = "org.kde.kdeconnect.app"; }
              { app-id = "thunderbird"; }
              { app-id = "fluffychat"; }
              { app-id = "teams-for-linux"; }
            ];
            open-on-workspace = "";
          }
          {
            # This rule applies to all windows as it has no 'matches'
            geometry-corner-radius = {
              bottom-left = 5.0;
              bottom-right = 0.0;
              top-left = 5.0;
              top-right = 5.0;
            };
            clip-to-geometry = true;
          }
        ];

        binds = {
          "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
          "Mod+Return" = {
            action.spawn = "${pkgs.ghostty}/bin/ghostty";
            hotkey-overlay.title = "Open a Terminal: Ghostty";
          };

          "Mod+Shift+Return" = {
            action.spawn = "alacritty";
            hotkey-overlay.title = "Open a Terminal: Alacritty";
          };
          "Mod+e" = {
            action.spawn = "${pkgs.kdePackages.dolphin}/bin/dolphin";

            hotkey-overlay.title = "Open Dolphin file browser";
          };
          "Mod+B" = {
            action.spawn = "zen";
            hotkey-overlay.title = "Open browser: Zen";
          };
          "Mod+Shift+B" = {
            action.spawn = "vivaldi";
            hotkey-overlay.title = "Open browser: Vivaldi";
          };
          "Mod+Space" = {
            action.spawn = [ "${pkgs.anyrun}/bin/anyrun" ];
            hotkey-overlay.title = "Anyrun (if it works...)";
          };
          # "Mod+Alt+Space" = {
          #   action.spawn = [
          #     "vivaldi"
          #     "--app=chrome-extension://kghbmcgihmefcbjlfiafjcigdcbmecbf/globalSearch.html?searchString=&initiallyUnlocked="
          #   ];
          #   hotkey-overlay.title = "HeyLogin Quick Access";
          # };
          "Mod+D" = {
            action.spawn = [
              "wofi"
              "--show"
              "drun"
            ];
            hotkey-overlay.title = "Dynamic Runner";
          };
          "Mod+Shift+D" = {
            action.spawn = [ "krunner" ];
            hotkey-overlay.title = "Krunner";
          };
          "Alt+Space" = {
            action.spawn = [ "krunner" ];
            hotkey-overlay.title = "Krunner";
          };
          "Mod+V" = {
            action.spawn = [
              "sh"
              "-c"
              "cliphist list | wofi --dmenu | cliphist decode | wl-copy"
            ];
            hotkey-overlay.title = "Clipboard History";
          };

          "Mod+Period" = {
            action.spawn = [
              "qdbus"
              "org.kde.krunner"
              "/App"
              "org.kde.krunner.App.querySingleRunner"
              "emojirunner"
              "emoji "
            ];
            hotkey-overlay.title = "Emoji Picker (KRunner)";
          };

          "Mod+P" = {
            repeat = false;
            action.spawn-sh = "wl-mirror ''$(niri msg --json focused-output | jq -r .name)";
          };

          # Audio media keys
          XF86AudioRaiseVolume = {
            action.spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.02+"
            ];
            allow-when-locked = true;
          };
          XF86AudioLowerVolume = {
            action.spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.02-"
            ];
            allow-when-locked = true;
          };

          XF86AudioMute = {
            action.spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ];
            allow-when-locked = true;
          };
          XF86AudioMicMute = {
            action.spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SOURCE@"
              "toggle"
            ];
            allow-when-locked = true;
          };

          # Other  media keys, brightness:
          XF86MonBrightnessDown = {
            allow-when-locked = true;
            action.spawn = [
              "brightnessctl"
              "set"
              "1%-"
            ];
          };
          XF86MonBrightnessUp = {
            allow-when-locked = true;
            action.spawn = [
              "brightnessctl"
              "set"
              "+1%"
            ];
          };
          # Next/previous track keys:
          XF86AudioNext = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "next"
            ];
          };
          XF86AudioPrev = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "previous"
            ];
          };
          XF86AudioPlay = {
            allow-when-locked = true;
            action.spawn = [
              "playerctl"
              "play-pause"
            ];
          };

          "Mod+O".action.toggle-overview = [ ];
          "Mod+Q".action.close-window = [ ];

          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Down".action.focus-window-or-workspace-down = [ ];
          "Mod+Up".action.focus-window-or-workspace-up = [ ];
          "Mod+Right".action.focus-column-right = [ ];
          "Mod+Shift+Left".action.move-column-left = [ ];
          "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = [ ];
          "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = [ ];
          "Mod+Shift+Right".action.move-column-right = [ ];

          "Mod+L".action.focus-column-right = [ ];
          "Mod+J".action.focus-window-or-workspace-down = [ ];
          "Mod+K".action.focus-window-or-workspace-up = [ ];
          "Mod+H".action.focus-column-left = [ ];
          "Mod+Shift+H".action.move-column-left = [ ];
          "Mod+Shift+J".action.move-window-down-or-to-workspace-down = [ ];
          "Mod+Shift+K".action.move-window-up-or-to-workspace-up = [ ];
          "Mod+Shift+L".action.move-column-right = [ ];

          "Mod+Home".action.focus-column-first = [ ];
          "Mod+End".action.focus-column-last = [ ];
          "Mod+Ctrl+Home".action.move-column-to-first = [ ];
          "Mod+Ctrl+End".action.move-column-to-last = [ ];

          "Mod+Ctrl+Left".action.focus-monitor-left = [ ];
          "Mod+Ctrl+Down".action.focus-monitor-down = [ ];
          "Mod+Ctrl+Up".action.focus-monitor-up = [ ];
          "Mod+Ctrl+Right".action.focus-monitor-right = [ ];
          "Mod+Ctrl+H".action.focus-monitor-left = [ ];
          "Mod+Ctrl+J".action.focus-monitor-down = [ ];
          "Mod+Ctrl+K".action.focus-monitor-up = [ ];
          "Mod+Ctrl+L".action.focus-monitor-right = [ ];
          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];
          "Mod+Page_Down".action.focus-workspace-down = [ ];
          "Mod+Page_Up".action.focus-workspace-up = [ ];
          "Mod+U".action.focus-workspace-down = [ ];
          "Mod+I".action.focus-workspace-up = [ ];
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
          "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];
          "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
          "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
          "Mod+Shift+U".action.move-workspace-down = [ ];
          "Mod+Shift+I".action.move-workspace-up = [ ];

          "Mod+WheelScrollRight" = {
            action.focus-column-right = [ ];
            cooldown-ms = 150;
          };
          "Mod+WheelScrollLeft" = {
            action.focus-column-left = [ ];
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollDown" = {
            action.move-column-to-workspace-down = [ ];
            cooldown-ms = 150;
          };
          "Mod+Ctrl+WheelScrollUp" = {
            action.move-column-to-workspace-up = [ ];
            cooldown-ms = 150;
          };
          "Mod+WheelScrollDown" = {
            action.focus-window-or-workspace-down = [ ];
            cooldown-ms = 150;
          };
          "Mod+WheelScrollUp" = {
            action.focus-window-or-workspace-up = [ ];
            cooldown-ms = 150;
          };
          "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
          "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;

          "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
          "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
          "Mod+M".action.consume-window-into-column = [ ];
          "Mod+Comma".action.expel-window-from-column = [ ];
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+Shift+R".action.switch-preset-window-height = [ ];

          # Half
          "Mod+Alt+H".action.set-column-width = "50%";
          # K: Dutch "kwart" (quarter), i.e. 25%
          "Mod+Alt+K".action.set-column-width = "25%";

          "Mod+Ctrl+R".action.reset-window-height = [ ];
          "Mod+F".action.maximize-column = [ ];
          "Alt+Return".action.fullscreen-window = [ ];

          # Expand the focused column to space not taken up by other fully visible columns.
          # Makes the column "fill the rest of the space".
          "Mod+Shift+F".action.expand-column-to-available-width = [ ];
          # Center all fully visible columns on screen.
          "Mod+C".action.center-visible-columns = [ ];
          # Center focused column
          "Mod+Ctrl+C".action.center-column = [ ];

          "Mod+Minus".action.set-column-width = "-5%";
          "Mod+Equal".action.set-column-width = "+5%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Mod+Z".action.toggle-window-floating = [ ];
          "Mod+Shift+Z".action.switch-focus-between-floating-and-tiling = [ ];
          "Mod+W".action.toggle-column-tabbed-display = [ ];

          "Mod+Shift+S".action.screenshot = [ ];
          "Mod+Ctrl+Shift+S".action.screenshot-screen = [ ];
          "Mod+Alt+Shift+S".action.screenshot-window = [ ];
          "Print".action.screenshot = [ ];
          "Ctrl+Print".action.screenshot-screen = [ ];
          "Alt+Print".action.screenshot-window = [ ];

          "Mod+Ctrl+Escape" = {
            action.toggle-keyboard-shortcuts-inhibit = [ ];
            allow-inhibiting = false;
          };

          "Mod+Shift+Escape".action.spawn = "wlogout";
          "Mod+Escape" = {
            action.spawn = [
              "sh"
              "-c"
              "niri msg action spawn -- hyprlock && niri msg action power-off-monitors"
            ];
            hotkey-overlay.title = "Lock the system";
          };
        };

        # --- Debug ---
        debug.honor-xdg-activation-with-invalid-serial = true;
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
          position = "bottom";
          height = 30;
          margin = "5 15 0 15";
          spacing = 5;

          modules-center = [
            "niri/workspaces"
            "niri/window"
          ];
          modules-left = [
            "custom/media"
            "clock"
            "clock#ohio"
            "clock#evie"
          ];

          modules-right = [
            "tray"
            (if hostname == "Fennekin" then "custom/osktoggle" else "")
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
            format = "🇳🇱 {:%H:%M}";
            format-alt = "<big>{:%Y %B}</big>\n<tt><small>{%c}</small></tt>";
          };
          "clock#ohio" = {
            "timezone" = "America/New_York";
            "format" = "🇺🇸 🫪 {:%H:%M}";
            "tooltip-format" = "<big>Lily/Lena</big>\n<tt><small>{%c}</small></tt>";
          };
          "clock#evie" = {
            "timezone" = "Europe/London";
            "format" = "🇬🇧 🐸 {:%H:%M}";
            "tooltip-format" = "<big>Evie</big>\n<tt><small>{%c}</small></tt>";
          };

          cpu = {
            format = " {usage}% ";
            on-click = "alacritty -e btop -p 1";
          };

          memory = {
            format = " {}% ";
            on-click = "alacritty -e btop -p 0";
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
            on-click = "nm-connection-editor";
            on-click-right = "alacritty -e nmtui connect";

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
          font-size: 16px;
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

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-cosmic ];
      config.common.default = [ "gtk" ];
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 10;
          }
        ];
        input-field = {
          size = "300,300";
          outline_thickness = 3;
          dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
          outer_color = "rgb(151515)";
          inner_color = "rgb(FFFFFF)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = false;
          fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
          placeholder_text = "<i>  </i>"; # Text rendered in the input box when it's empty.
          hide_input = true;
          rounding = -1; # -1 means complete rounding (circle/oval)
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
          fail_text = ""; # can be set to empty
          fail_transition = 300; # transition time in ms between normal outer_color and fail_color
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false; # change color if numlock is off
          swap_font_color = false; # see below
          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };

    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "niri msg action quit --skip-confirmation";
          text = "Logout";
          keybind = "e";
        }

        {
          label = "shutdown";
          action = "poweroff";
          text = "Shutdown";
          keybind = "s";
        }

        {
          label = "reboot";
          action = "reboot";
          text = "Reboot";
          keybind = "r";
        }

        {
          label = "hibernate";
          action = "niri msg action open-overview; niri msg action spawn -- hyprlock && systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }

        {
          label = "suspend";
          action = "niri msg action spawn -- hyprlock && systemctl suspend-then-hibernate";
          text = "Sleep";
          keybind = "z";
        }
      ];
      style = ''

        * {
          font-family: "Lotion Black", FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        	background-image: none;
        	transition: 20ms;
        	box-shadow: none;
        }

        window {
        	background-color: rgba(12, 12, 12, 0.8);
        }

        button {
        	color: #FFFFFF;
          font-size:20px;
        	margin: 10px;
        	border-radius: 20px;
          background-repeat: no-repeat;
        	background-position: center;
        	background-size: 25%;
          background-color: unset;
        	border-style: solid;
        	border: 3px solid #FFFFFF;
          box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
        }

        #lock {
        	background-image: image(url("icons/lock.png"));
          background-color: #7facb3;
        }

        #logout {
        	background-image: image(url("icons/logout.png"));
          background-color: #ff4500;
        }

        #shutdown {
        	background-image: image(url("icons/shutdown.png"));
          background-color: #8b0000;
        }

        #reboot {
        	background-image: image(url("icons/reboot.png"));
          background-color: #556b2f;
        }

        #hibernate {
        	background-image: image(url("icons/hibernate.png"));
          background-color: #368cf9;
        }
        #suspend {
        	background-image: image(url("icons/suspend.png"));
          background-color: #f4d3a7;
        }

        button:focus,
        button:active,
        button:hover {
          color: #FFFFFF;
        	border: 3px solid #FFFFFF;
          background-color: #ffffff;
        }
      '';
    };

    xdg.configFile."wlogout/icons" = {
      source = ../../configs/wlogout-icons;
      recursive = true;
    };
    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
          "${pkgs.anyrun}/lib/libapplications.so"
          "${pkgs.anyrun}/lib/librunner.so"
          "${pkgs.anyrun}/lib/libsymbols.so"
        ];
        width.fraction = 0.4;
        y.fraction = 0.3;
        hideIcons = false;
        closeOnClick = true;
      };
      extraCss = "/*todo*/";
    };
  };

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    wayland-utils
    wl-clipboard
    xclip
    xwayland-satellite
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprlock = { };

  security.polkit.enable = true;
}
