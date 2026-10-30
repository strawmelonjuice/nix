{ pkgs, ... }:
{
  home.packages = [ pkgs.ghostty ];
  xdg.configFile."ghostty/config.light".text = ''
    # Rose Pine Dawn
    background = #f7f3ee
    foreground = #575279
    palette = 0=#f2e9e1
    palette = 1=#b4637a
    palette = 2=#286983
    palette = 3=#ea9d34
    palette = 4=#56949f
    palette = 5=#907aa9
    palette = 6=#d7827e
    palette = 7=#575279
    palette = 8=#e4dfde
    palette = 9=#b4637a
    palette = 10=#286983
    palette = 11=#ea9d34
    palette = 12=#56949f
    palette = 13=#907aa9
    palette = 14=#d7827e
    palette = 15=#575279
  '';
  xdg.configFile."ghostty/config.dark".text = ''
    # Tokyo Night
    background = #1a1b26
    foreground = #a9b1d6
    palette = 0=#15161e
    palette = 1=#f7768e
    palette = 2=#9ece6a
    palette = 3=#e0af68
    palette = 4=#7aa2f7
    palette = 5=#bb9af7
    palette = 6=#7dcfff
    palette = 7=#a9b1d6
    palette = 8=#414868
    palette = 9=#f7768e
    palette = 10=#9ece6a
    palette = 11=#e0af68
    palette = 12=#7aa2f7
    palette = 13=#bb9af7
    palette = 14=#7dcfff
    palette = 15=#c0caf5
  '';
}
