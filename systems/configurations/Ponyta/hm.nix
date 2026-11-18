{ pkgs, ... }:
{
  imports = [
    ../../../home-manager/modules/conversation.nix
    ../../../home-manager/modules/entertainment/music-streaming.nix

    # ../../../home-manager/modules/development/jetbrainspackages.nix
    ../../../home-manager/modules/school.nix

    ../../../home-manager/modules/development/exercism.nix
  ];

  home.packages = with pkgs; [
    jetbrains-toolbox
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
