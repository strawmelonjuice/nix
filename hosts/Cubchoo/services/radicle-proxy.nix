{ pkgs, ... }: {
  systemd.services.rad-proxy-sync = {
    description = "Auto-fetch Radicle proxied repositories";

    script = ''
      export RAD_HOME=/home/mar/.radicle
      shopt -s nullglob

      for repo in /cubchoo/radicle-proxied/*/*.git; do
        if [ -d "$repo" ]; then
          echo "Syncing $repo..."
          cd "$repo"
          
          ${pkgs.radicle-node}/bin/rad sync --fetch || true
          
          ${pkgs.git}/bin/git fetch rad || true
        fi
      done
    '';

    serviceConfig = {
      Type = "oneshot";
      User = "mar";
      Group = "users";
    };
  };

  systemd.timers.rad-proxy-sync = {
    description = "Timer for auto-fetching Radicle proxied repositories";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "10m";
      Unit = "rad-proxy-sync.service";
    };
  };
}
