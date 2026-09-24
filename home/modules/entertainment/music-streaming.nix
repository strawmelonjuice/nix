{ pkgs, inputs, ... }:
{
  home.packages = [
    # pkgs.spotify
    pkgs.strawberry
    # Trying... it no seem workie.
    inputs.puppy-toetaps.packages.citrineGui
  ];
}
