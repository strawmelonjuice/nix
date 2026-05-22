{
  pkgs,
  config,
  ...
}:

{
  imports = [
    # Development
    ./modules/development.nix
    ./modules/development/vcs.nix
    ./modules/development/neovim.nix
    # Shell
    ./modules/shell/kc.nix
    ./modules/shell/zsh.nix
  ];

  home.username = "mar";
  home.homeDirectory = "/home/mar";
  home.stateVersion = "25.11"; # Ensure this matches your NixOS version

  programs.direnv = {
    silent = true;
    enable = true;
  };
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transbian";
      mode = "rgb";
      light_dark = "light";
      lightness = 1.0;
      color_align = {
        mode = "horizontal";
      };
      backend = "macchina";
      pride_month_disable = false;
    };

  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;

    defaultCacheTtl = 28800;
    maxCacheTtl = 28800;
  };
  home.file.".ssh/config_shared" = {
    source = ../configs/ssh-config;
  };

  xdg.configFile."zellij" = {
    source = ../configs/zellij;
    recursive = true;
  };

  xdg.configFile."starship.toml" = {
    source = ../configs/starship.toml;
  };

  home.packages = with pkgs; [
    eza
    bat
    zoxide
    starship
    hyfetch
    macchina
    zellij
    fzf
    xsel
    jq
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # 'librewolf.desktop' or 'vivaldi-stable.desktop' or...
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "application/pdf" = "zen.desktop";
      "application/x-extension-htm" = "zen.desktop";
      "application/x-extension-html" = "zen.desktop";
      "application/x-extension-shtml" = "zen.desktop";
      "application/x-extension-xhtml" = "zen.desktop";
      "application/x-extension-xht" = "zen.desktop";
      "x-scheme-handler/obsidian" = "obsidian.desktop";
    };
  };

  home.sessionVariables.SHELL = "zsh";

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
