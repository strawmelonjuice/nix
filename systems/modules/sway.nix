{
  pkgs,
  config,
  cfg,
  lib,
  ...
}:
let
  hmconfig = config.home-manager.users.mar;
in
{
  imports = [
    ./gdm.nix
  ];
  home-manager.users.mar =
    let
      config = hmconfig;
    in
    {
      imports = [
        ../../home-manager/configurations/workstation.nix
      ];
      wayland.windowManager.sway = {
        enable = true;
        config = {
          modifier = "Mod4";
          terminal = "ghostty";
          startup = [
            { command = "firefox"; }
          ];
          keybindings =
            let
              modifier = config.wayland.windowManager.sway.config.modifier;
            in
            lib.mkOptionDefault {
              "${modifier}+Return" = "exec ${cfg.config.terminal}";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+d" = "exec ${cfg.config.menu}";
            };
        };
      };

      services.fnott = {
        enable = true;
        settings.main = {
          anchor = "bottom-right";
          default-timeout = 15;
        };
      };

    };
  security.polkit.enable = true;
  users.users.mar.extraGroups = [ "video" ];
  security.pam.services.swaylock = { };
  environment.systemPackages = with pkgs; [
    grim
    slurp
    pinentry-qt
    polkit_gnome
    wayland-utils
    wl-clipboard
    xclip
    xwayland-satellite
    wl-clipboard
  ];

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

}
