{ pkgs, lib, ... }: {
  programs.fish.enable = true;
  programs.fish.shellInit =
    let
      fishStart = lib.mkOrder 500 ''
        # Have to have ssh-agent running now for yubikey sk-ed25519
        if status is-interactive; and not set -q SH_STARTED
            set -gx SH_STARTED 1
            eval (ssh-agent -c)
            clear
            ${pkgs.hyfetch}/bin/hyfetch
        end
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
