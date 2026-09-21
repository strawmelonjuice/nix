{
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [ restic ];

  programs.radicle.settings = lib.mkForce { };
  home.sessionVariables.RAD_HOME = "/var/lib/radicle";

  services.podman.enable = lib.mkForce false;
}
