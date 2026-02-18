{ pkgs, ... }:

{
  imports = [
    ./niri/anyrun.nix
    ./niri/noctalia.nix
  ];
  home.packages = with pkgs; [
    niri
    kdePackages.krunner
    pavucontrol
    btop
    # htop
    hyprlock
    # mako
    libnotify
    xwayland-satellite
    wireplumber
    kdePackages.kdeconnect-kde
    brightnessctl
    wl-clipboard
    cliphist
    playerctl
    blueman
    killall
    wvkbd
    wlogout
    # swww
    # fuzzel
    # waybar
    # waybar-mpris
    # I should make a proper input and a flake out of this but instead I'll be lazy and yeet the .so into my dotfiles.
    # (
    #   if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
    #     (runCommand "libniri-taskbar" { } ''
    #       mkdir -p $out/lib
    #       cp -r ${../../libs}/linux-x64/libniri-taskbar.so $out/lib/libniri-taskbar.so
    #     '')
    #   else
    #     cowsay
    # )
  ];
  xdg.configFile."niri/config.kdl" = {
    source = ../../configs/niri/config.kdl;
  };
  xdg.configFile."niri/scripts/osk.sh" = {
    text = ''
      #!/run/current-system/sw/bin/bash
      # Relaunch the touch keyboard if it crashed

      line=$(ps -C wvkbd-mobintl --no-headers)
      if [ -z "$line" ]; then
        wvkbd-mobintl -L 300
      else
        echo $line >/dev/null
        # Its running, so send it a signal to toggle it up
        kill -34 $(ps -C wvkbd-mobintl)
      fi
    '';
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
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 10;
        }
      ];
      input-field = {
        size = "300,300";
        outline_thickness = 3;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "rgb(151515)";
        inner_color = "rgb(FFFFFF)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = false;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = "<i>  </i>"; # Text rendered in the input box when it's empty.
        hide_input = true;
        rounding = -1; # -1 means complete rounding (circle/oval)
        check_color = "rgb(204, 136, 34)";
        fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
        fail_text = ""; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below
        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
  };
}
