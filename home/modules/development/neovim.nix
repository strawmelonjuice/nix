{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # NIX-STYLE: Bundled binaries for your LazyVim config
    extraPackages = with pkgs; [
      lua-language-server
      nil
      ripgrep
      fd
      git
      gcc
      tree-sitter
      lazygit
      lazyjj
    ];

    initLua = ''
      -- Prepend the symlinked directory to the Runtime Path
      vim.opt.rtp:prepend("${config.home.homeDirectory}/.config/nvim")
      require("init")
    '';
  };
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
        L = ":theme bogster_light";
        g = ":theme github_dark_high_contrast";
        G = ":theme rose_pine_moon";
        d = ":theme iroaseta";
        D = ":theme tokyonight_moon";
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

  xdg.configFile."nvim".source = ../../../configs/nvim;
}
