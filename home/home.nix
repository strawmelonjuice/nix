{
  pkgs,
  inputs,
  hostname,
  ...
}:

{
  imports = [
    # Inputs
    inputs.plasma-manager.homeModules.plasma-manager

    # Modules
    ./modules/conversation.nix
    ./modules/development.nix
    ./modules/fonts.nix
    ./modules/games.nix
    ./modules/gnome.nix
    ./modules/kde.nix
    ./modules/librewolf.nix
    ./modules/niri.nix
    ./modules/shell.nix
    ./modules/spotify.nix
    ./modules/wezterm.nix
  ]
  ++ [
    ./host-specific/${hostname}.nix
  ];

  home.username = "mar";
  home.homeDirectory = "/home/mar";
  home.stateVersion = "24.11"; # Ensure this matches your NixOS version

  home.packages = with pkgs; [
    # GUI Apps
    vivaldi

    #gnomeExtensions.gesture-improvements
    gnomeExtensions.appindicator
    git
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "vivaldi-stable.desktop";
      "x-scheme-handler/http" = "vivaldi-stable.desktop";
      "x-scheme-handler/https" = "vivaldi-stable.desktop";
      "x-scheme-handler/about" = "vivaldi-stable.desktop";
      "x-scheme-handler/unknown" = "vivaldi-stable.desktop";
      "application/xhtml+xml" = "vivaldi-stable.desktop";
      "application/x-extension-htm" = "vivaldi-stable.desktop";
      "application/x-extension-html" = "vivaldi-stable.desktop";
      "application/x-extension-shtml" = "vivaldi-stable.desktop";
      "application/x-extension-xhtml" = "vivaldi-stable.desktop";
      "application/x-extension-xht" = "vivaldi-stable.desktop";
    };
  };

  home.sessionVariables = {
    TERMINAL = "wezterm";
    PASSWORD_STORE_TYPE = "basic";
    ZED_ALLOW_EMULATED_GPU = 1;
    SHELL = "fish";
  };
}
