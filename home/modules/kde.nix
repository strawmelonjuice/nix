{ pkgs, lib, hostname, ... }:

# Please find this earlier next time
# https://nix-community.github.io/plasma-manager/options.xhtml

{
  home.activation = {
    removePlasmaCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.cache/plasmashell*
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.cache/plasma*
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.cache/kiopp*
    '';
  };
  home.packages = with pkgs; [
    layan-cursors
  ];
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    kscreenlocker.appearance.wallpaper = "/home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pink-clouds.png";
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breeze.desktop";
      colorScheme = "BreezeLight";
      cursor.theme = "Layan-cursors";
      iconTheme = "breeze";
      wallpaper = "/home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pink-clouds.png";
    };
    configFile.kdeglobals.General.AccentColor = "245,194,231";
    configFile.kdeglobals.General.LastUsedCustomAccentColor = "245,194,231";

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
                  "applications:vivaldi-stable.desktop"
                  "applications:org.wezfurlong.wezterm.desktop"
                  "applications:obsidian.desktop"
                  "applications:Fluffychat.desktop"
                ] ++ (if hostname == "fennekin" then [
                  "applications:com.github.xournalpp.xournalpp.desktop"
                ] else []);
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
}
