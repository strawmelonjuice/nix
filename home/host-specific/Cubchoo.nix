{ pkgs, config, ... }: {
  programs.radicle.settings.node.externalAddresses = [ "strawmelonjuice.com:8776" ];

  programs.zsh.shellAliases.watch-temperature = "sudo watch -n 1 \"vcgencmd measure_temp && cat /sys/class/thermal/cooling_device0/cur_state\"  ";
  home.packages = with pkgs; [ restic ];

  # Shared network ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman = {
    networks = {
      "server-net" = {
        autoStart = true;
      };
    };
  };
  # Main database ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # - Moved to nix service

  # Caddy ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # - Mostly moved to nix service

  # Owncloud ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Add symlink between Owncloud files <-> Home folders
  home.file."media/music" = {
    source = config.lib.file.mkOutOfStoreSymlink "/cubchoo/owncloud/data/files/mar/files/Music";
    force = true;
  };

  systemd.user.services.owncloud = {
    Service = {
      ExecStart = pkgs.writeShellScript "owncloud-starter" ''
        # if [ ! -f "${config.xdg.configHome}/services/OwnCloud/.env" ]; then
        # 	echo "Missing file : ${config.xdg.configHome}/services/OwnCloud/.env"
        # 	exit 1
        # fi
        cd "${config.xdg.configHome}/services/OwnCloud" && ${pkgs.podman-compose}/bin/podman-compose --env-file ./.env --project-name cloud up 
      '';
    };
    Install.WantedBy = [ "default.target" ];
  };

  # Define composefile
  xdg.configFile."services/OwnCloud/docker-compose.yml".text = ''
    networks:
      owncloud-net:

    volumes:
      redis:
        driver: local

    services:
      owncloud:
        image: owncloud/server:latest
        container_name: owncloud_server
        extra_hosts:
          - "host.containers.internal:host-gateway"
        depends_on:
          - redis
        environment:
          - OWNCLOUD_DOMAIN=cloud.strawmelonjuice.nl
          - OWNCLOUD_TRUSTED_DOMAINS=cloud.strawmelonjuice.nl
          - OWNCLOUD_ADMIN_USERNAME=mar
          # - OWNCLOUD_ADMIN_PASSWORD=''${OWNCLOUD_ADMIN_PASSWORD}
          - OWNCLOUD_REDIS_ENABLED=true
          - OWNCLOUD_REDIS_HOST=redis
          # Main db
          - OWNCLOUD_DB_TYPE=pgsql 
          - OWNCLOUD_DB_NAME=owncloud
          - OWNCLOUD_DB_USERNAME=owncloud
          - OWNCLOUD_DB_PASSWORD=owncloud
          - OWNCLOUD_DB_HOST=host.containers.internal
        healthcheck:
          test: ["CMD", "/usr/bin/healthcheck"]
          interval: 30s
          timeout: 10s
          retries: 5
        volumes:
          - /cubchoo/owncloud/data/:/mnt/data:Z
        ports:
          - 38080:8080
        networks:
          owncloud-net:
        deploy:
          resources:
            limits:
              memory: 2G
      redis:
        image: redis:6
        container_name: owncloud_redis
        command: ["--databases", "1"]
        healthcheck:
          test: ["CMD", "redis-cli", "ping"]
          interval: 10s
          timeout: 5s
          retries: 5
        volumes:
          - redis:/data
        networks:
          owncloud-net:
            aliases: 
              - redis
        deploy:
          resources:
            limits:
              memory: 1G
  '';

  # Strawmelonjuice media share ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman.containers.mediajuice = {
    autoStart = true;
    image = "docker.io/strawmelonjuice/strawmediajuice:1.2.1";
    network = "server-net";
    networkAlias = [ "strawmedia" ];
    environment = {
      PORT = 3022;
    };
    volumes = [
      "${config.home.homeDirectory}/services/data/strawmediajuice:/app/data:Z"
    ];

    extraPodmanArgs = [
      "--memory 100m"
      "--memory-reservation 512m"
    ];
  };

  # Matrix ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # The 'old' host on strawmelonjuice.com
  # https://continuwuity.org/deploying/docker.html#caddy-using-caddyfile
  services.podman.containers.matrix-main = {
    autoStart = true;
    # network = "host";
    ports = [
      "18008:8008"
    ];
    image = "forgejo.ellis.link/continuwuation/continuwuity:latest-maxperf";
    environment = {
      CONTINUWUITY_SERVER_NAME = "matrix.strawmelonjuice.com";
      CONTINUWUITY_DATABASE_PATH = "/var/lib/continuwuity";
      CONTINUWUITY_ADDRESS = "0.0.0.0";
      CONTINUWUITY_PORT = 8008;
      CONTINUWUITY_WELL_KNOWN__SERVER = "matrix.strawmelonjuice.com:443";
      JEMALLOC_SYS_WITH_LG_PAGE = "14";
    };
    volumes = [
      "/cubchoo/matrix-old/continuwuity-db:/var/lib/continuwuity"
      "${builtins.toFile "resolv.conf" ''
        nameserver 1.0.0.1
        nameserver 1.1.1.1
      ''}:/etc/resolv.conf"
    ];
    extraPodmanArgs = [
      "--memory 1g"
      "--memory-swap 1g"
      "--memory-reservation 512m"
    ];
  };

  # Backups ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  systemd.user.services.services-backups = {
    Unit.Description = "Backups";
    Service = {
      MemoryHigh = "4G";
      MemoryMax = "6G";
      ExecStart = pkgs.writeShellScript "backups" ''
        	BACKUP_DIR="${config.home.homeDirectory}/backups_temp"
        	DATA_DIR="${config.home.homeDirectory}/services/data"
        	TIMESTAMP=$(date +"%Y-%m-%d-%H.%M")
        	ARCHIVE_NAME="$TIMESTAMP.tar.zst"
        	FINAL_DEST="${config.home.homeDirectory}/backups"

        	mkdir -p $BACKUP_DIR
        	mkdir -p $FINAL_DEST

        	echo "Dumping database..."
        	rm -fr  $BACKUP_DIR/full_db_backup.sql
        	${pkgs.podman}/bin/podman exec main-database pg_dumpall -U postgres > $BACKUP_DIR/full_db_backup.sql


        	# echo "Copying local dotfiles..."
        	# ${pkgs.rsync}/bin/rsync -rlptDX --delete "${config.home.homeDirectory}/.dotfiles/" "$BACKUP_DIR/local_dotfiles/"

        	echo "Copying data folder..."
        	# sudo cp -r $DATA_DIR $BACKUP_DIR/data_files
        	# sudo rm -fr $BACKUP_DIR/data_files/owncloud/data/files/mar/files/Music
        	sudo ${pkgs.rsync}/bin/rsync -rlptDX --delete --exclude='owncloud/data/files/mar/files/Music' "$DATA_DIR/" "$BACKUP_DIR/data_files/"
        	sudo chown mar:mar -R "$BACKUP_DIR"

        	echo "Uploading any new or updated music..."
        	${pkgs.rsync}/bin/rsync --bwlimit=4000 -hrvPt --update --size-only ${config.home.homeDirectory}/media/music/ frigometri::music/

                echo "Streaming deduplicated snapshot to remote target over SSH..."
                ${pkgs.restic}/bin/restic -r sftp:frigometri:/home/mar/backups backup --insecure-no-password \
                  "$BACKUP_DIR" \
                  "${config.home.homeDirectory}/.dotfiles"

                echo "Pruning old snapshots..."
                ${pkgs.restic}/bin/restic -r sftp:frigometri:/home/mar/backups forget --keep-daily 7 --keep-weekly 4 --prune --insecure-no-password
        	echo "Backup for $TIMESTAMP complete!"
      '';
    };
  };
  systemd.user.timers.services-backups = {
    Unit.Description = "Daily backup at half past eleven.";
    Timer = {
      OnCalendar = "*-*-* 23:30:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

}
