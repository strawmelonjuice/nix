{ pkgs, ... }:
{
  imports = [
    ../modules/conversation.nix
    ../modules/entertainment/music-streaming.nix
  ];

  programs.niri.settings.outputs.eDP-1 = {
    variable-refresh-rate = "on-demand";
    mode = {
      width = 1920;
      height = 1200;
      refresh = 120.0;
    };
  };

  home.stateVersion = "26.05"; # Ensure this matches your NixOS version
}
