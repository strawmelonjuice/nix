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
    mako
    libnotify
    xwayland-satellite
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
  xdg.configFile."mako/config".text = ''
    # General
    font=Atkinson Hyperlegible Next 12
    width=350
    height=150
    padding=15
    margin=10
    anchor=top-right

    # Colors
    background-color=#e06666
    # Text matched to @textcolor1 (#000000)
    text-color=#000000

    # Border styling
    # Matched to @bordercolor (#f4cccc)
    border-color=#f4cccc
    border-size=2
    # Matched to #window border-radius (12px)
    border-radius=12

    # Icons
    icons=1
    max-icon-size=48
    progress-color=#9b4457

    # Options
    default-timeout=5000
    ignore-timeout=0

    # Urgency overrides
    [urgency=low]
    background-color=#f4cccc
    border-color=#e06666
    default-timeout=2000
    text-color=#000000

    [urgency=high]
    background-color=#fa8071
    border-color=#ffffff
    text-color=#000000
    border-size=3

    [urgency=critical]
    default-timeout=0

    # "Command is done" override
    [app-name=wezterm]
    background-color=#9b4457
    default-timeout=2000
    ignore-timeout=1
    [app-name=ibus]
    invisible=1
    default-timeout=2000
    ignore-timeout=1
  '';
}
