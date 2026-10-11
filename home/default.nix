{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Development
    ./modules/development.nix
    ./modules/development/vcs.nix
    ./modules/development/neovim.nix
    ./modules/development/helix.nix

    # Shell
    ./modules/shell.nix

    inputs.direnv-instant.homeModules.direnv-instant
  ];
  news.display = "silent";

  home.file.".ssh/config_shared" = {
    source = ../configs/ssh-config;
  };
  home.username = "mar";
  home.homeDirectory = "/home/mar";

  home.packages = with pkgs; [
    home-manager
  ];

  nix.package = lib.mkForce pkgs.lixPackageSets.stable.lix;
  nix.extraOptions = "experimental-features = nix-command flakes";

  services.podman.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = "${config.home.homeDirectory}/desktop";
    download = "${config.home.homeDirectory}/desktop/downloads";

    music = "${config.home.homeDirectory}/media/music";
    videos = "${config.home.homeDirectory}/media/videos";
    pictures = "${config.home.homeDirectory}/media/pictures";

    documents = "${config.home.homeDirectory}/files/documents";
    publicShare = "${config.home.homeDirectory}/files/documents/public";
    templates = "${config.home.homeDirectory}/files/templates";
    projects = "${config.home.homeDirectory}/files/projects";
    extraConfig = {
      SOURCE = "${config.home.homeDirectory}/files/projects";
    };
  };

  home.file = {
    "files/projects/repos/forge.strawmelonjuice.com/.keep".text = "";
    "files/projects/repos/codeberg.org/.keep".text = "";
    "files/projects/repos/tangled.sh/.keep".text = "";
    "files/projects/repos/github.com/.keep".text = "";
  };

}
