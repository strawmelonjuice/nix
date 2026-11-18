{ pkgs, lib, ... }: {
  programs.fish.enable = true;
  programs.fish.shellInit =
    let
      fishStart = lib.mkOrder 500 ''
        if status is-interactive; and not set -q SH_STARTED
        	set -gx SH_STARTED 1
        	eval (ssh-agent -c)
        	ssh-add ~/.ssh/id_ed25519_sk_rk_ssh_strawmelonjuice_main ~/.ssh/id_ed25519_sk_rk_ssh_strawmelonjuice_sign
        	if not gpg --list-keys B278044AB3B50ADC0090FDC5D982294C0247929F >/dev/null 2>&1
        		echo "Key missing. Fetching from strawmelonjuice.nl..."
        		curl -sSL https://strawmelonjuice.nl/me.asc | gpg --import
        	end
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
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.autopair
  ];
  home.file.".local/scripts/rad-proxy-git-hook.sh".source =
    ../../../configs/scripts/rad-proxy-git-hook.sh

  ;
}
