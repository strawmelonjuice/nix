{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # I'll still use Fluffy from the browser, but since it seems to want to break very much,
    # locally I'll have element...
    telegram-desktop
    cinny-desktop
    signal-desktop
  ];
}
