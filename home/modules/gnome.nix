{
  pkgs,
  lib,
  hostname,
  ...
}:

{
  dconf.settings = {
    "org/gnome/desktop/applications/browser" = {
      exec = "vivaldi-stable";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        pkgs.gnomeExtensions."appindicator".extensionUuid
        pkgs.gnomeExtensions."dash-to-dock".extensionUuid
        pkgs.gnomeExtensions."night-theme-switcher".extensionUuid
        pkgs.gnomeExtensions."blur-my-shell".extensionUuid
        pkgs.gnomeExtensions."search-light".extensionUuid
        pkgs.gnomeExtensions."all-in-one-clipboard".extensionUuid
      ];
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "vivaldi-stable.desktop"
        "org.wezfurlong.wezterm.desktop"
        "obsidian.desktop"
        "Fluffychat.desktop"
      ]
      ++ (
        if hostname == "Fennekin" then
          [
            "com.github.xournalpp.xournalpp.desktop"
          ]
        else if hostname == "Ponyta" then
          [
          ]
        else
          [ ]
      );
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      always-center-icons = true;
      apply-custom-theme = true;
      background-opacity = 0.80000000000000004;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = true;
      height-fraction = 0.90000000000000002;
      icon-size-fixed = false;
      scroll-action = "switch-workspace";
      show-mounts = false;
      show-thrash = false;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/pink-clouds.png";
      picture-uri-dark = "file:///home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/wallhaven-9mjw78.png";
      picture-options = "zoom"; # "zoom", "centered", "scaled", etc.
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/mar/.local/share/wallpapers/aesthetic-wallpapers/images/wallhaven-9mjw78.png";
    };
    "org/gnome/desktop/interface" = {
      # color-scheme = "prefer-light"; # Handled by daynight plugin
      enable-hot-corners = false;
      show-battery-percentage = true;
    };
    "org/gnome/settings-daemon/plugins/orientation" = {
      active = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-schedule-automatic = true;
    };
    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      nightthemeswitcher-ondemand-keybinding = [
        (lib.hm.gvariant.mkString "<Shift><Super>t")
      ];
    };
    "org/gnome/system/location".enabled = true;
  };
  home.packages = with pkgs; [
    dconf-editor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.all-in-one-clipboard
    gnomeExtensions.search-light
  ];
}
