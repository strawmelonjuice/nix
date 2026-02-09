{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
    local wezterm = require('wezterm')
    local config = wezterm.config_builder()
    config.color_scheme = 'Atelier Heath Light (base16)'
    config.enable_tab_bar = false
    config.window_background_opacity = 0.8
    config.font = wezterm.font('Lotion Black')
    config.font_size = 9
    config.window_close_confirmation = 'NeverPrompt'
    -- and finally, return the configuration to wezterm
    return config
    '';
  };
}
