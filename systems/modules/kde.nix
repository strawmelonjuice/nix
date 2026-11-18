{
  lib,
  pkgs,
  config,
  inputs,
  home-manager,
  ...
}:
{
  imports = [
    ./gdm.nix
  ];
  # Please find this earlier next time
  # https://nix-community.github.io/plasma-manager/options.xhtml
  home-manager.users.mar = {
    imports = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];
    home = {
      packages = with pkgs; [
        layan-cursors
      ];
    };
    programs = {
      plasma = {
        enable = true;
        overrideConfig = true;
        krunner.position = "center";
        kscreenlocker.appearance.wallpaper = "/home/mar/.local/share/wallpapers/current_wallpaper.png";
        workspace = {
          clickItemTo = "select";
          cursor.theme = "layan-cursors";
          iconTheme = "Oxygen";
          wallpaper = [
            "${config.home-manager.users.mar.home.homeDirectory}/.local/share/wallpapers/slideshow/1.png"
            "${config.home-manager.users.mar.home.homeDirectory}/.local/share/wallpapers/slideshow/2.png"
            "${config.home-manager.users.mar.home.homeDirectory}/.local/share/wallpapers/slideshow/3.png"
          ];
        };
        configFile.kdeglobals.General.AccentColor = "245,194,231";
        configFile.kdeglobals.General.LastUsedCustomAccentColor = "245,194,231";

        # Get touchpad names by running cat /proc/bus/input/devices
        input.touchpads = [
          # Fennekin's touchpad
          {
            disableWhileTyping = false;
            enable = true;
            leftHanded = false;
            middleButtonEmulation = true;
            name = "ELAN0749:00 04F3:31A5 Touchpad";
            naturalScroll = true;
            pointerSpeed = 0;
            productId = "31a5";
            tapToClick = true;
            vendorId = "04f3";
          }
          # Ponyta's touchpad
          {
            disableWhileTyping = false;
            enable = true;
            leftHanded = false;
            middleButtonEmulation = true;
            name = "ASUE1306:00 04F3:3284 Touchpad";
            naturalScroll = true;
            pointerSpeed = 0;
            productId = "3284";
            tapToClick = true;
            vendorId = "04f3";
          }

        ];

        panels = [
          {
            location = "top";
            height = 48;
            floating = true;
            widgets = [
              "org.kde.plasma.kickoff"

              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General = {
                    launchers = [
                      "applications:zen.desktop"
                      "applications:com.mitchellh.ghostty.desktop"
                      "applications:obsidian.desktop"
                      "applications:Fluffychat.desktop"
                    ];
                    showOnlyLauncher = "false";
                    showTasksOnlyOnCurrentScreen = "false";
                    showTasksOnlyOnCurrentDesktop = "false";
                    groupingStrategy = 0;
                    onlyGroupWhenFull = "false";
                    separateLaunchers = "false";
                  };
                };
              }

              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
            ];
          }
        ];
      };
    };
  };
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with pkgs; [
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kclock
    kdePackages.kcolorchooser
    kdePackages.ksystemlog
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
  ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    konversation
    kpat # Solitaire
    ksudoku
    discover
    ktorrent
    merkuro
    kontact
    ktnef
    kdepim-runtime
    korganizer
  ];

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
