{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "html"
      "catppuccin"
      "toml"
      "catppuccin-icons"
      "lua"
      "nix"
      "rose-pine-theme"
      "gleam"
      "zed-just"
      "discord-presence"
      "fish"
      "kdl"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    userSettings = {
      buffer_font_family = "Hermit";
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
      icon_theme = "Catppuccin Macchiato";
      # helix_mode = true;
    };
  };

}
