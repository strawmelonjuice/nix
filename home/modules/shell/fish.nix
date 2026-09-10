{ pkgs, lib, ... }: {
  programs.fish.enable = true;
  programs.fish.shellInit =
    let
      fishStart = lib.mkOrder 500 ''
        # Have to have ssh-agent running now for yubikey sk-ed25519
        eval $(ssh-agent)
        clear
        ${pkgs.hyfetch}/bin/hyfetch
      '';
      fishFile = lib.mkOrder 1100 (builtins.readFile ../../../configs/config.fish);
    in
    lib.mkMerge [
      fishStart
      fishFile
    ];
  programs.fish.generateCompletions = true;

  home.packages = with pkgs; [
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    fishPlugins.autopair
  ];
}
