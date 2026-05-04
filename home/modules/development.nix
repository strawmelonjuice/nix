{ pkgs, ... }:

{
  programs.mise = {
    enable = false;
    enableZshIntegration = false;
  };
  home.packages = with pkgs; [
    # Mise is being faded out in favor of just due to growing friction between me and Mise's style
    just-lsp
    just
    nixfmt
    nil
    # I make a lot of things with Inkscape actually!
    inkscape
  ];
}
