{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # School: Python and Dbus to run their network script
    python312
    python312Packages.dbus-python
    python313Packages.pydbus
    dbus
    # School: Run Windows software
    wineWow64Packages.stable
    winetricks
    # School: Uses Teams for direct communications.
    # 'teams' exists but only for Darwin...
    teams-for-linux # does exist...
  ];
}
