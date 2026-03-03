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
      outline_panel.dock = "right";
      project_panel.dock = "right";
      notification_panel.dock = "right";
      # And hide some.
      collaboration_panel.button = false;
      agent.button = false;
      git_panel.button = false;

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
