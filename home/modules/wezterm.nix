{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
       local get_time_of_day = function()
      	local hour = tonumber(os.date("%H"))
      	if hour >= 6 and hour < 12 then
          -- morning
       		return "Atelier Heath Light (base16)"
      	elseif hour >= 12 and hour < 18 then
          -- afternoon
       		return "Atelier Heath Light (base16)"
      	elseif hour >= 18 and hour < 24 then
          -- evening
       		return "tokyonight_night"
      	else
          -- night
       		return "tokyonight_night"
      	end
       end
       local wezterm = require('wezterm')
       local config = wezterm.config_builder()
       config.color_scheme = get_time_of_day()
       config.enable_tab_bar = false
       config.window_background_opacity = 1.0
       config.font = wezterm.font('Maple Mono NF')
       config.window_padding = {
          left = 5,
          right = 5,
          top = 5,
          bottom = 5,
       }
       config.font_size = 9
       config.window_close_confirmation = 'NeverPrompt'
       -- and finally, return the configuration to wezterm
       return config
    '';
  };
}
