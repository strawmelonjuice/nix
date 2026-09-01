{ config, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [ "${config.home.homeDirectory}/.local/share/wallpapers/alacritty-theme.toml" ];
      };
      font = {
        normal.family = config.home.sessionVariables.PREFERRED_MONO_FONT;
      };
    };
  };
}
