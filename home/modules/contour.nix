{ pkgs, ... }:
let

  common = ''
    theme: system

    profiles:
      main:
        colors: main
  '';

in
{
  home.packages = [ pkgs.contour ];
  # rose-pine-dawn
  xdg.configFile."contour/contour.yml.light".text = common + ''
    color_schemes:
      main:
        default:
          background: "#f7f3ee"
          foreground: "#575279"
        normal:
          black:   "#f2e9e1"
          red:     "#b4637a"
          green:   "#286983"
          yellow:  "#ea9d34"
          blue:    "#56949f"
          magenta: "#907aa9"
          cyan:    "#d7827e"
          white:   "#575279"
        bright:
          black:   "#e4dfde"
          red:     "#b4637a"
          green:   "#286983"
          yellow:  "#ea9d34"
          blue:    "#56949f"
          magenta: "#907aa9"
          cyan:    "#d7827e"
          white:   "#575279"
      mars-rosy-dawn:
        default:
          background: "#FFF0F5"
          foreground: "#575279"
        normal:
          black:   "#f2e9e1"
          red:     "#a50036"
          green:   "#286983"
          yellow:  "#ea9d34"
          blue:    "#56949f"
          magenta: "#907aa9"
          cyan:    "#d7827e"
          white:   "#575279"
        bright:
          black:   "#e4dfde"
          red:     "#b4637a"
          green:   "#286983"
          yellow:  "#ea9d34"
          blue:    "#56949f"
          magenta: "#907aa9"
          cyan:    "#d7827e"
          white:   "#575279"
  '';

  # tokyo-night
  xdg.configFile."contour/contour.yml.dark".text = common + ''
    color_schemes:
      main:
        default:
          background: "#1a1b26"
          foreground: "#a9b1d6"
        normal:
          black:   "#15161e"
          red:     "#f7768e"
          green:   "#9ece6a"
          yellow:  "#e0af68"
          blue:    "#7aa2f7"
          magenta: "#bb9af7"
          cyan:    "#7dcfff"
          white:   "#a9b1d6"
        bright:
          black:   "#414868"
          red:     "#f7768e"
          green:   "#9ece6a"
          yellow:  "#e0af68"
          blue:    "#7aa2f7"
          magenta: "#bb9af7"
          cyan:    "#7dcfff"
          white:   "#c0caf5"
  '';
}
