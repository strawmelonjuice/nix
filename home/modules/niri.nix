{ pkgs, ... }:

{
  imports = [
    ./niri/anyrun.nix
  ];
  home.packages = with pkgs; [
    niri
    kdePackages.krunner
    pavucontrol
    btop
    htop
    fuzzel
    waybar
    hyprlock
    waybar-mpris
    wireplumber
    brightnessctl
    blueman
    swww
    killall
    wvkbd
    wlogout
    # I should make a proper input and a flake out of this but instead I'll be lazy and yeet the .so into my dotfiles.
    (
      if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
        (runCommand "libniri-taskbar" { } ''
          mkdir -p $out/lib
          cp -r ${../../libs}/linux-x64/libniri-taskbar.so $out/lib/libniri-taskbar.so
        '')
      else
        cowsay
    )
  ];
  xdg.configFile."niri/config.kdl" = {
    source = ../../configs/niri/config.kdl;
  };
  xdg.configFile."fuzzel/fuzzel.ini" = {
    source = ../../configs/niri/fuzzel.ini;
  };
  xdg.configFile."waybar/config" = {
    source = ../../configs/niri/waybar/config.jsonc;
  };
  xdg.configFile."waybar/modules.jsonc" = {
    source = ../../configs/niri/waybar/modules.jsonc;
  };
  xdg.configFile."waybar/style.css" = {
    source = ../../configs/niri/waybar/style.css;
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
