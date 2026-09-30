{ ... }: {
  # Helix ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  programs.helix = {
    enable = true;
    settings = {
      theme = "flatwhite";
      editor.line-number = "relative";
      editor.mouse = true;
      editor.cursor-shape.insert = "bar";
      editor.cursor-shape.normal = "block";
      editor.cursor-shape.select = "underline";
      editor.file-picker.hidden = false;
      keys.normal = {
        "C-s" = ":write";
      };
      keys.normal.space.M = {
        l = ":theme flatwhite";
        L = ":theme base16_default_light";
        d = ":theme tokyonight_moon";
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
