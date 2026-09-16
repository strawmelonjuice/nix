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
}
