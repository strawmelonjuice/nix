{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fluffychat
    # ... unbridged signal again after the people decided I should
    signal-desktop
  ];
}
