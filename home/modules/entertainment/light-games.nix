{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pandora-launcher
  ];
}
