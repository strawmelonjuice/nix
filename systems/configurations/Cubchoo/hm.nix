{
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ../../../home-manager/modules/development.nix
    ../../../home-manager/modules/development/vcs.nix
    ../../../home-manager/modules/development/neovim.nix
    ../../../home-manager/modules/development/helix.nix
    ../../../home-manager/modules/shell.nix
  ];
  news.display = "silent";

  home.file.".ssh/config_shared" = {
    source = ../../../configs/ssh-config;
  };
  home.username = "mar";
  home.homeDirectory = "/home/mar";

  home.packages = with pkgs; [
    home-manager
    helix
    restic
    radicle-node
  ];

  nix.package = lib.mkForce pkgs.lixPackageSets.stable.lix;
  nix.extraOptions = "experimental-features = nix-command flakes";

  programs.jujutsu = {
    settings.signing.backend = lib.mkForce "ssh";
    settings.signing.key = lib.mkForce "~/.ssh/id_ed25519";
  };
  programs.git.settings.user.signingkey = lib.mkForce "~/.ssh/id_ed25519";

  home.sessionVariables.RAD_HOME = "/var/lib/radicle";

  services.podman.enable = false;

  home.stateVersion = "26.05";
}
