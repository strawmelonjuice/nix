{ pkgs, ... }:
{
  home.username = "mar";
  home.homeDirectory = "/home/mar";
  home.stateVersion = "26.05"; # Ensure this matches your NixOS version
}
