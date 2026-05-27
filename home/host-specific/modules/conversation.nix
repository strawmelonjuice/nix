{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # cinny-desktop <- Seems browser works better, can't copy/paste and stuff
  ];
}
