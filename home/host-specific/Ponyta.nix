{ pkgs, ... }:
{
  imports = [
    ../modules/gnome.nix
    ../modules/conversation.nix
    ../modules/entertainment/music-streaming.nix

    # ../modules/development/jetbrainspackages.nix
    ../modules/school.nix

    ../modules/development/exercism.nix
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
