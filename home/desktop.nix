{
  pkgs,
  config,
  ...
}:
{
  imports = [
    # Enviroments ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ./modules/cosmic.nix
    ./modules/kde.nix
    ./modules/niri.nix

    # Graphical development ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./modules/development/vscodium.nix
    # ./modules/development/gram.nix

    # Browsers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./modules/zen.nix
    # ./modules/librewolf.nix
    #-> And vivaldi, which is configured non-declaratively.

    # Graphical terminal emulator ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ./modules/wezterm.nix
    ./modules/alacritty.nix

    # Entertainment ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./modules/entertainment/light-games.nix

    # Misc. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ./modules/fonts.nix
  ];

  home.username = "mar";
  home.homeDirectory = "/home/mar";

  home.packages = with pkgs; [
    oo7-portal
    # GUI Apps
    vivaldi
    crosspipe
    nextcloud-client
    kdePackages.filelight

    # Additional to the radicle CLI
    # just because I find the radicle idea so cool
    radicle-desktop

    # I make a lot of things with Inkscape actually!
    inkscape
  ];

  programs.obs-studio = {
    enable = true;
    # enableVirtualCamera = true;
  };

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

      # Obsidian for obsidian
      "x-scheme-handler/obsidian" = "obsidian.desktop;md.Obsidian.desktop;";

      #jetbrains for jetbrains ???

      "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";

      # Thunderbird for thunderbird things

      "x-scheme-handler/mailto" = "userapp-Thunderbird-2NFCS3.desktop";
      "message/rfc822" = "userapp-Thunderbird-2NFCS3.desktop";
      "x-scheme-handler/mid" = "userapp-Thunderbird-2NFCS3.desktop";
      "x-scheme-handler/news" = "userapp-Thunderbird-Y55CS3.desktop";
      "x-scheme-handler/snews" = "userapp-Thunderbird-Y55CS3.desktop";
      "x-scheme-handler/nntp" = "userapp-Thunderbird-Y55CS3.desktop";
      "x-scheme-handler/feed" = "userapp-Thunderbird-U91AS3.desktop";
      "application/rss+xml" = "userapp-Thunderbird-U91AS3.desktop";
      "application/x-extension-rss" = "userapp-Thunderbird-U91AS3.desktop";
      "x-scheme-handler/webcal" = "userapp-Thunderbird-FM1PS3.desktop";
      "text/calendar" = "userapp-Thunderbird-FM1PS3.desktop";
      "application/x-extension-ics" = "userapp-Thunderbird-FM1PS3.desktop";
      "x-scheme-handler/webcals" = "userapp-Thunderbird-FM1PS3.desktop";

    };
  };

  home.sessionVariables.TERMINAL = "alacritty";
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.PASSWORD_STORE_TYPE = "basic";

  home.sessionVariables.BACKGROUND_LIGHT = "${config.home.homeDirectory}/.local/share/wallpapers/aesthetic-wallpapers/images/gruvbox_room.png";
  home.sessionVariables.BACKGROUND_DARK = "${config.home.homeDirectory}/.local/share/wallpapers/aesthetic-wallpapers/images/purple-girl.png";
  home.sessionVariables.TERM_THEME_LIGHT = "rose_pine_dawn";
  home.sessionVariables.TERM_THEME_DARK = "tokyo_night_enhanced";
  home.sessionVariables.PREFERRED_MONO_FONT = "Maple Mono NF";

  services.kdeconnect.enable = true;
  services.nextcloud-client.enable = true;
  services.tailscale-systray.enable = true;
  # services.rsibreak.enable = true;
  services.safeeyes.enable = true;
  services.awww.enable = true;

  systemd.user.services.wallpaper-switcher = {
    Unit.Description = "Swap wallpaper based on time";
    Install.WantedBy = [ "graphical.target" ];
    Service = {
      ExecStart = pkgs.writeShellScript "swap-wall" ''
                                # Since the timer sets up a bit faster 
                                # than a desktop can load in, we give it a
                                # minute to think before it acts.
                                # sleep 60
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
                                  # Fake slideshow!
                                  cp --update=all ${config.home.sessionVariables.BACKGROUND_DARK} /home/mar/.local/share/wallpapers/slideshow/1
                                  cp --update=all ${config.home.sessionVariables.BACKGROUND_DARK} /home/mar/.local/share/wallpapers/slideshow/2
                                  cp --update=all ${config.home.sessionVariables.BACKGROUND_DARK} /home/mar/.local/share/wallpapers/slideshow/3
                                  # But we can just set it manually much better.
                                  ${pkgs.awww}/bin/awww img ${config.home.sessionVariables.BACKGROUND_DARK}

                        	  ${pkgs.dconf} write /org/gnome/desktop/interface/color-scheme '"prefer-dark"'
                		  # KDE is in this episode too
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage ${config.home.sessionVariables.BACKGROUND_DARK} || true
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-lookandfeel --apply org.kde.breezedark.desktop || true
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme KritaDarkOrange || true
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-cursortheme "layan-cursors" || true


        			  ln -f -s ${pkgs.alacritty-theme}/share/alacritty-theme/${config.home.sessionVariables.TERM_THEME_DARK}.toml "${config.home.homeDirectory}/.local/share/wallpapers/alacritty-theme.toml"
                                else
                                  # Day time
                                  echo "Good day~!";
                                  ln -sf /home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pixel_big_city.png /home/mar/.local/share/wallpapers/current_wallpaper.png
                                  # Here too
                                  cp --update=all ${config.home.sessionVariables.BACKGROUND_LIGHT} /home/mar/.local/share/wallpapers/slideshow/1
                                  cp --update=all ${config.home.sessionVariables.BACKGROUND_LIGHT} /home/mar/.local/share/wallpapers/slideshow/2
                                  cp --update=all ${config.home.sessionVariables.BACKGROUND_LIGHT} /home/mar/.local/share/wallpapers/slideshow/3
                                  # But we can just set it manually much better.
                                  ${pkgs.awww}/bin/awww img ${config.home.sessionVariables.BACKGROUND_LIGHT}

                        	  ${pkgs.dconf} write /org/gnome/desktop/interface/color-scheme '"prefer-light"'
                		  # KDE is in this episode too
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage ${config.home.sessionVariables.BACKGROUND_LIGHT} || true
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-lookandfeel --apply org.kde.breeze.desktop || true
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeClassic || true
                                  ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-cursortheme "layan-cursors" || true

        			  ln -f -s ${pkgs.alacritty-theme}/share/alacritty-theme/${config.home.sessionVariables.TERM_THEME_LIGHT}.toml "${config.home.homeDirectory}/.local/share/wallpapers/alacritty-theme.toml"
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
