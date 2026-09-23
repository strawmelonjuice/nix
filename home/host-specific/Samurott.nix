{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/entertainment/light-games.nix
    ../modules/entertainment/music-streaming.nix
    ../modules/conversation.nix
    ../modules/school.nix
    # Huge screen, may run jetbrains
    ../modules/development/jetbrainspackages.nix
  ];
  home.packages = with pkgs; [
    wineWow64Packages.stable
    winetricks
    libreoffice-stable
  ];
  programs.niri.settings.outputs."Microstep MSI MP341CQ 0x00000316" = {
    variable-refresh-rate = "on-demand";
    mode = {
      width = 3440;
      height = 1440;
      refresh = 100.0;
    };
    position = {
      x = 0;
      y = 0;
    };
  };
  programs.niri.settings.outputs."Hewlett Packard HP E202 3CQ7450ZT4" = {
    position = {
      x = 3440;
      y = 0;
    };
    scale = 1.15;
  };
}
