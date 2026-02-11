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
      config.font = wezterm.font('Maple Mono NF')
      config.font_size = 10
      config.window_close_confirmation = 'NeverPrompt'
      -- and finally, return the configuration to wezterm
      return config
    '';
  };
}
