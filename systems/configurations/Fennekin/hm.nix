{
  lib,
  ...
}:
{
  imports = [
    ../../../home-manager/modules/touchscreen.nix
    ../../../home-manager/modules/conversation.nix
    ../../../home-manager/modules/entertainment/music-streaming.nix
  ];

  programs.niri.settings.outputs.eDP-1 = {
    mode = {
      width = 1920;
      height = 1080;
      refresh = 40.000;
    };
    scale = 1.10;
  };
  home.stateVersion = "25.11"; # Ensure this matches your NixOS version
}
