{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wakatime-cli
    just-lsp
    just
    nixfmt
    nil
  ];
}
