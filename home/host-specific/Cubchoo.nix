{
  pkgs,
  lib,
  ...
}:
{
  programs.helix = {
    package = lib.mkForce pkgs.helix;
    settings.theme = lib.mkForce "default";
  };
  programs.jujutsu = {
    settings.signing.backend = lib.mkForce "ssh";
    settings.signing.key = lib.mkForce "~/.ssh/id_ed25519";
  };
  programs.git.settings.user.signingkey = lib.mkForce "~/.ssh/id_ed25519";

  home.packages = with pkgs; [ restic ];

  programs.radicle.settings = lib.mkForce { };
  systemd.user.services.radicle-node = lib.mkForce { };
  home.sessionVariables.RAD_HOME = "/var/lib/radicle";

  services.podman.enable = lib.mkForce false;

  home.stateVersion = "26.05";
}
