{ pkgs, ... }:

{
  imports = [
    ./shell/kc.nix
    ./shell/zsh.nix
  ];
  programs.direnv = {
    silent = true;
    enable = true;
  };
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "sapphic";
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
    source = ../../configs/ssh-config;
  };

  xdg.configFile."zellij" = {
    source = ../../configs/zellij;
    recursive = true;
  };

  xdg.configFile."starship.toml" = {
    source = ../../configs/starship.toml;
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
}
