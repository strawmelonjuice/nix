{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "rust"
      "gleam"
      "fish"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
    ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "One Dark";
        light = "One Light";
      };
      hour_format = "hour24";
      # helix_mode = true;
    };
  };

}
