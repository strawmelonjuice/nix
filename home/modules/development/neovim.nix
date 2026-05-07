{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wakatime-cli
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;

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
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      require("config.options")

      local path_package = vim.fn.stdpath("data") .. "/site/"
      local mini_path = path_package .. "pack/deps/start/mini.deps"
      if not vim.loop.fs_stat(mini_path) then
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.deps", mini_path })
        vim.cmd("packadd mini.deps")
      end

      local MiniDeps = require("mini.deps")
      MiniDeps.setup({ path = { package = path_package } })
      local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

      now(function()
        add("folke/tokyonight.nvim")
        add("EdenEast/nightfox.nvim")
        add("nvim-tree/nvim-web-devicons")
        add("folke/which-key.nvim")
        add("nvim-lualine/lualine.nvim")


        local hour = tonumber(os.date("%H"))
        local is_dark = (hour < 6 or hour >= 19)
        local theme = is_dark and "tokyonight-night" or "dayfox"
        
        vim.o.termguicolors = true
        vim.o.background = is_dark and "dark" or "light"
        vim.cmd.colorscheme(theme)
       
      end)

      later(function()
        add("neovim/nvim-lspconfig")
        add("stevearc/conform.nvim")
        require("config.lsp")
        require("config.fmt")


        add({
          source = "nvim-treesitter/nvim-treesitter",
          hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
        })

        add("folke/snacks.nvim")
        require("snacks").setup({
          dashboard = {
            enabled = true,
            sections = {
              { section = "header", padding = 5 }, -- Alleen je mooie ASCII art
            },
            preset = {
              header = [[
      ===================================================================
      -------------------------   Mar's Nvim!   -------------------------
      ===================================================================

                  Welcome! It's time to start doing stuff! :3
              ]],
            }
          },
          picker = { enabled = true },
          explorer = { enabled = true },
        })
        
        local lualine = require("plugins.lualine")
        add("nvim-lua/plenary.nvim")
        add("swaits/lazyjj.nvim")
        add("kdheepak/lazygit.nvim")
        require("plugins.gvc").setup()

        add("wakatime/vim-wakatime")
        add("vyfor/cord.nvim")
        
        require("which-key").setup({})
        require("config.keymaps")
        require("config.autocmds")
        
        
      end)
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
}
