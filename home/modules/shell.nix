{ pkgs, ... }:

{
  imports = [
    ./shell/kc.nix
  ];
  programs.fish = {
    enable = true;
  };
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

  xdg.configFile."fish" = {
    source = ../../configs/fish;
    recursive = true;
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
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    xsel
    jq
  ];
}
