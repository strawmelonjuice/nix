{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # cinny-desktop <- Seems letting Vivaldi create a PWA everytime works better, can't copy/paste and stuff
    # ... unbridged signal again after the people decided I should
    signal-desktop
  ];
}
