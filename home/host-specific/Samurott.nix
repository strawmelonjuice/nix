{
  pkgs,
  ...
}:
{
  imports = [
    ./modules/steam.nix
    ./modules/conversation.nix
    ./modules/music-streaming.nix
    ./modules/school.nix
    ./modules/kde.nix
  ];
  home.packages = with pkgs; [
    wineWow64Packages.stable
    winetricks
    libreoffice-fresh
  ];
}
