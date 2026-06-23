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
    ./modules/development/gram.nix
    ./modules/development/vscodium.nix

    # Browsers --------------------------------------------------------------------------------------------------------------
    # ./modules/librewolf.nix
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
    crosspipe
    owncloud-client
    # I make a lot of things with Inkscape actually!
    inkscape
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # 'librewolf.desktop' or 'zen.desktop' or...
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
      "application/xhtml+xml" = "vivaldi-stable.desktop";
      "application/pdf" = "vivaldi-stable.desktop";
      "application/x-extension-htm" = "vivaldi-stable.desktop";
      "application/x-extension-html" = "vivaldi-stable.desktop";
      "application/x-extension-shtml" = "vivaldi-stable.desktop";
      "application/x-extension-xhtml" = "vivaldi-stable.desktop";
      "application/x-extension-xht" = "vivaldi-stable.desktop";
      "x-scheme-handler/obsidian" = "obsidian.desktop";
    };
  };

  home.sessionVariables.TERMINAL = "wezterm";
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.PASSWORD_STORE_TYPE = "basic";

  systemd.user.services.wallpaper-switcher = {
    Unit.Description = "Swap wallpaper based on time";
    Service = {
      ExecStart = pkgs.writeShellScript "swap-wall" ''
                                                     mkdir -p /home/mar/.local/share/wallpapers/slideshow
                                                     if [ ! -d "/home/mar/.local/share/wallpapers/aesthetic-wallpapers" ]; then
                                                       git clone https://github.com/D3Ext/aesthetic-wallpapers.git /home/mar/.local/share/wallpapers/aesthetic-wallpapers
                                                     fi

                                                     # Wait for awww-daemon to be ready
                                                     until ${pkgs.awww}/bin/awww query >/dev/null 2>&1; do
                                                       echo "Waiting for awww-daemon..."
                                                       sleep 1
                                                     done

                                                     HOUR=$(date +%H)
                                                     if [ $HOUR -ge 19 ] || [ $HOUR -lt 8 ]; then
                                                       # Night time: 19:00 to 07:59
                				       echo "Good night!";
                                                       ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/current_wallpaper.png
                                                       # Fake slideshow!
                                                       cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/slideshow/1.png
                                                       cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/slideshow/2.png
                                                       cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png /home/mar/.local/share/wallpapers/slideshow/3.png
                                                       # ${pkgs.awww}/bin/awww img /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pastel-window.png
                                             	       # AWWW supports whatever!
                        			       ${pkgs.awww}/bin/awww img /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/retro_city.gif
                                                     else
                                                       # Day time
                				       echo "Good day~!";
                                                       ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/current_wallpaper.png
                                                       # Here too
                                                       cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/slideshow/1.png
                                                       cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/slideshow/2.png
                                                       cp --update=all /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/slideshow/3.png
        					       # AWWW supports whatever!
                                                       ${pkgs.awww}/bin/awww img /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png
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
