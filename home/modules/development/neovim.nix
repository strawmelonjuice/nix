{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wakatime-cli
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # Lua tools for the editor running on Lua
      lua-language-server
      stylua

      # Taplo, TOML ls,linter and formatter
      taplo

      # Unzip is depended on for unzipping certain dependencies.
      # I have decided not to be too opinionated about this today.
      unzip

      # AST-Grep
      ast-grep

      # Node is required as runtime for some LSP's, among them css-ls and tailwindcss-ls
      nodejs

      # SQL linter-formatter
      sqlfluff

      # Markdown LSP and toc creator
      markdown-oxide
      markdown-toc

      # Inclusivity linter
      woke

      # More generic web-oriented linter-formatters: Biome, Prettier
      biome
      prettier

      # And duh
      nil
      nixfmt

      # FD
      fd

      # TS
      tree-sitter

      # GCC
      gcc

      # RG
      ripgrep
    ];

    initLua = ''
      -- Prepend the symlinked directory to the Runtime Path
      vim.opt.rtp:prepend("${config.home.homeDirectory}/.config/nvim")
      require("config.lazy")
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

  xdg.configFile."nvim/lua".source = ../../../configs/nvim/lua;
  xdg.configFile."nvim/lazyvim.json".source = ../../../configs/nvim/lazyvim.json;
}
