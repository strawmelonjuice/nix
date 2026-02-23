{ pkgs, ... }:

{
  programs.vscode = {
    package = pkgs.vscodium;
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs; [
          vscode-extensions.bbenoist.nix
          vscode-extensions.tamasfe.even-better-toml
          vscode-extensions.rust-lang.rust-analyzer
          vscode-extensions.gleam.gleam
          vscode-extensions.catppuccin.catppuccin-vsc
          vscode-extensions.catppuccin.catppuccin-vsc-icons
          vscode-extensions.mvllow.rose-pine
          vscode-extensions.jjk.jjk
          vscode-extensions.mkhl.direnv
        ];
        userSettings = {
          editor.fontFamily = "'Maple Mono NF', 'Droid Sans Mono', monospace";
          window.autoDetectColorScheme = true;
          workbench.preferredDarkColorTheme = "Catppuccin Mocha";
          workbench.preferredLightColorTheme = "Rosé Pine Dawn";
          workbench.iconTheme = "rose-pine-icons";
          workbench.sideBar.location = "right";
          security.workspace.trust.enabled = false;
          window.newWindowProfile= "Default";
        };
      };
    };
  };
}
