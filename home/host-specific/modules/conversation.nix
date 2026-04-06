{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fluffychat
    # Until I set up bridging between discord and @mar:strawmelonjuice.com
    discord
    # ... unbridged signal again after the people decided I should
    signal-desktop
  ];
}
