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

      # Force all panels to the right dock
      collaboration_panel.dock = "right";
      outline_panel.dock = "right";
      git_panel.dock = "right";
      project_panel.dock = "right";
      notification_panel.dock = "right";
      agent.dock = "right";

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
