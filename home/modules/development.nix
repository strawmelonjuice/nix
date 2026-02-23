{ pkgs, ... }:

{
  imports = [
    ./development/jujutsu.nix
    ./development/neovim.nix
    ./development/zed.nix
    ./development/vscodium.nix
  ];
  programs.mise = {
    enable = true;
  };
  home.packages = with pkgs; [
    # Mise is being faded out in favor of just due to growing friction between me and Mise's style
    just
    just-lsp
    # I make a lot of things with Inkscape actually!
    inkscape
  ];
}
