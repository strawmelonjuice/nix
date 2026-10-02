{
  config,
  inputs, pkgs,
  ...
}:
{
  # Helix ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      theme = {
        fallback = "flatwhite";
        dark = "tokyonight_moon";
        light = "flatwhite";
      };
      editor.line-number = "relative";
      editor.mouse = true;
      editor.cursor-shape.insert = "bar";
      editor.cursor-shape.normal = "block";
      editor.cursor-shape.select = "underline";
      editor.file-picker.hidden = false;
      keys.normal = {
        "C-s" = ":write";
      };
      keys.normal.C-space = {
        l = ":theme ${config.programs.helix.settings.theme.light}";
        d = ":theme ${config.programs.helix.settings.theme.dark}";
        L = ":theme base16_default_light";
        D = ":theme iroaseta";
      };
      keys.insert = {
        "C-s" = [
          ":write"
          "normal_mode"
        ];
        down = [
          "move_visual_line_down"
          "normal_mode"
        ];
        up = [
          "move_visual_line_up"
          "normal_mode"
        ];
      };
    };
  };
}
