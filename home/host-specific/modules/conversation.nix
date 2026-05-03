{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cinny-desktop
    # ... unbridged signal again after the people decided I should
    signal-desktop
  ];
}
