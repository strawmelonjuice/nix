{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xournalpp
    krita
  ];

}
