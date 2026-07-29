{ pkgs, ... }:

{
  # Neovim ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

      # AST-Grep
      ast-grep

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

      # Web stuff lsp's
      tailwindcss-language-server
      typescript-language-server
      vscode-css-languageserver

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

  };
  xdg.configFile."nvim/lua".source = ../../../configs/nvim/lua;
  xdg.configFile."nvim/init.lua".source = ../../../configs/nvim/init.lua;

}
