{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./gdm.nix
  ];
  home-manager.users.mar = {
    imports = [
      ../../home-manager/configurations/workstation.nix
    ];
    dconf.settings = {
      "org/gnome/desktop/applications/browser" = {
        exec = "zen";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          pkgs.gnomeExtensions."appindicator".extensionUuid
          pkgs.gnomeExtensions."dash-to-dock".extensionUuid
          pkgs.gnomeExtensions."night-theme-switcher".extensionUuid
          pkgs.gnomeExtensions."blur-my-shell".extensionUuid
          pkgs.gnomeExtensions."search-light".extensionUuid
          pkgs.gnomeExtensions."clipboard-history-2".extensionUuid
          pkgs.gnomeExtensions."runcat".extensionUuid
          pkgs.gnomeExtensions."raccoon-launcher".extensionUuid
        ];
      };
      "org/gnome/shell" = {
        favorite-apps = [
          "zen.desktop"
          "com.mitchellh.ghostty.desktop"
          "md.obsidian.Obsidian.desktop"
          "Fluffychat.desktop"
        ];
      };
      "org/gnome/desktop/interface" = {
        monospace-font-name = "Maple Mono NF 11";
        accent-color = "green";
      };
      "org/gnome/desktop/wm/keybindings" = {

        switch-to-workspace-right = ([
          "<Super>Page_Down"
          "<Super>KP_Next"
          "<Super><Alt>Right"
          "<Control><Alt>Right"
          "<Super>J"
        ]);

        switch-to-workspace-left = ([
          "<Super>Page_Up"
          "<Super>KP_Prior"
          "<Super><Alt>Left"
          "<Control><Alt>Left"
          "<Super>K"
        ]);
      };
      "org/gnome/shell/extensions/raccoonlauncher".toggle-launcher = [
        "<Alt>space"
        "<Control>space"
      ];
      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = true;
        apply-custom-theme = true;
        background-opacity = 0.80000000000000004;
        custom-theme-shrink = true;
        isolate-workspaces = true;
        dash-max-icon-size = 48;
        dock-fixed = false;
        dock-position = "BOTTOM";
        # Means extend width in my case btw
        extend-height = false;
        height-fraction = 0.90000000000000002;
        icon-size-fixed = false;
        scroll-action = "switch-workspace";
        show-mounts = false;
        show-thrash = false;
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.home-manager.users.mar.home.sessionVariables.BACKGROUND_LIGHT}";
        # Hoping my systemd service works for gnome too
        picture-uri-dark = "file://${config.home-manager.users.mar.home.sessionVariables.BACKGROUND_DARK}";
        picture-options = "zoom"; # "zoom", "centered", "scaled", etc.
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file://${config.home-manager.users.mar.home.sessionVariables.BACKGROUND_LIGHT}";
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
          "<Shift><Super>t"
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
      gnomeExtensions.clipboard-history-2
      gnomeExtensions.search-light
      gnomeExtensions.runcat
      gnomeExtensions.raccoon-launcher
    ];
  };
}
