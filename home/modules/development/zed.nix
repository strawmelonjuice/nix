{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "rust"
      "lua"
      "gleam"
      "fish"
      "catppuccin"
      "catppuccin-icons"
      "rose-pine-theme"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    userSettings = {
      buffer_font_family = "Maple Mono NF";
      ui_font_family = "Lotion";
      session = {
        trust_all_worktrees = true;
      };
      base_keymap = "VSCode";
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Rosé Pine Dawn";
      };
      # helix_mode = true;
    };
  };

}
