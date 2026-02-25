{ pkgs, ... }:

{
  programs.vscode = {
    package = pkgs.vscodium;
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          tamasfe.even-better-toml
          rust-lang.rust-analyzer
          gleam.gleam
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          mvllow.rose-pine
          jjk.jjk
          nefrob.vscode-just-syntax
          mkhl.direnv
        ];
        userSettings = {
          editor.fontFamily = "'Hermit', 'Droid Sans Mono', monospace";
          window = {
            autoDetectColorScheme = true;
            newWindowProfile = "Default";
          };
          workbench = {
            preferredDarkColorTheme = "Catppuccin Mocha";
            preferredLightColorTheme = "Rosé Pine Dawn";
            iconTheme = "rose-pine-icons";
            sideBar.location = "right";
          };
          security.workspace.trust.enabled = false;
        };
      };
    };
  };
}
