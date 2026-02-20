{ pkgs, ... }:

{
  home.packages = with pkgs; [
    beeper
    fluffychat
    # Not agreeing with installing...
    discord
    # But alas, as beeper is being a bad girl and I'm not bothered to fix it.
  ];
}
