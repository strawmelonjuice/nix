{
  pkgs,
  ...
}:

{
  imports = [
    # Enviroments -----------------------------------------------------------------------------------------------------------
    ./modules/cosmic.nix
    ./modules/kde.nix
    ./modules/niri.nix

    # Graphical development -------------------------------------------------------------------------------------------------
    ./modules/development/zed.nix
    ./modules/development/vscodium.nix

    # Browsers --------------------------------------------------------------------------------------------------------------
    ./modules/librewolf.nix
    ./modules/zen.nix
    #-> And vivaldi, which is configured non-declaratively.

    # Graphical terminal emulator -------------------------------------------------------------------------------------------
    ./modules/wezterm.nix

    # Misc. -----------------------------------------------------------------------------------------------------------------
    ./modules/fonts.nix
    ./modules/games.nix
  ];

  home.username = "mar";
  home.homeDirectory = "/home/mar";
  home.stateVersion = "25.11"; # Ensure this matches your NixOS version

  home.packages = with pkgs; [
    # GUI Apps
    vivaldi
    # I make a lot of things with Inkscape actually!
    inkscape
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # 'librewolf.desktop' or 'vivaldi-stable.desktop' or...
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "application/pdf" = "zen.desktop";
      "application/x-extension-htm" = "zen.desktop";
      "application/x-extension-html" = "zen.desktop";
      "application/x-extension-shtml" = "zen.desktop";
      "application/x-extension-xhtml" = "zen.desktop";
      "application/x-extension-xht" = "zen.desktop";
      "x-scheme-handler/obsidian" = "obsidian.desktop";
    };
  };

  home.sessionVariables.TERMINAL = "wezterm";
  home.sessionVariables.PASSWORD_STORE_TYPE = "basic";
  home.sessionVariables.ZED_ALLOW_EMULATED_GPU = 1;

  systemd.user.services.wallpaper-switcher = {
    Unit.Description = "Swap wallpaper based on time";
    Service = {
      ExecStart = pkgs.writeShellScript "swap-wall" ''
        mkdir -p /home/mar/.local/share/wallpapers/slideshow
        if [ ! -d "/home/mar/.local/share/wallpapers/aesthetic-wallpapers" ]; then
          git clone https://github.com/D3Ext/aesthetic-wallpapers.git /home/mar/.local/share/wallpapers/aesthetic-wallpapers
        fi
        HOUR=$(date +%H)
        if [ $HOUR -ge 19 ] || [ $HOUR -lt 8 ]; then
          # Night time: 19:00 to 07:59
          ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/current_wallpaper.png
          # Fake slideshow!
          cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/slideshow/1.png
          cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/slideshow/2.png
          cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/slideshow/3.png
          noctalia-shell ipc call wallpaper set /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png ""
          noctalia-shell ipc call darkMode setDark
        else
            # Day time
          ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/current_wallpaper.png
          # Here too
          cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/slideshow/1.png
          cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/slideshow/2.png
          cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/slideshow/3.png
          noctalia-shell ipc call wallpaper set /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png ""
          noctalia-shell ipc call darkMode setLight
        fi
      '';
    };
  };

  # Run every hour
  systemd.user.timers.wallpaper-switcher = {
    Unit.Description = "Hourly wallpaper check";
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

}
