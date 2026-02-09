{ pkgs, ... }:

{
  imports = [
    ./niri/anyrun.nix
  ];
  home.packages = with pkgs; [
    niri
    kdePackages.krunner
    fuzzel
    waybar
    hyprlock
    swww
    wvkbd
    wlogout
  ];
  xdg.configFile."niri/config.kdl" = {
    source = ../../configs/niri/config.kdl;
  };
  xdg.configFile."fuzzel/fuzzel.ini" = {
    source = ../../configs/niri/fuzzel.ini;
  };
  xdg.configFile."waybar" = {
    source = ../../configs/niri/waybar;
    recursive = true;
  };
  xdg.configFile."wlogout" = {
    source = ../../configs/niri/wlogout;
    recursive = true;
  };
  xdg.configFile."hypr" = {
    source = ../../configs/niri/hypr;
    recursive = true;
  };
}
