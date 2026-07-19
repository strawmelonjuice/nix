{ pkgs, config, ... }: {
  targets.genericLinux.enable = true;
  programs.zsh.shellAliases.watch-temperature = "sudo watch -n 1 \"vcgencmd measure_temp && cat /sys/class/thermal/cooling_device0/cur_state\"  ";

  # Shared network ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman = {
    networks = {
      "server-net" = {
        autoStart = true;
      };
    };
  };
  # Main database ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman.containers.main-database = {
    autoStart = true;
    networkAlias = [
      "main-database"
      "db"
    ];
    network = "server-net";
    image = "postgres:18-alpine";
    environment = {
      "POSTGRES_HOST_AUTH_METHOD" = "trust";
    };
    volumes = [
      "${config.home.homeDirectory}/database:/var/lib/postgresql:Z"
      "${config.home.homeDirectory}/.config/services/main-database/postgresql.conf:/etc/postgresql/postgresql.conf:ro"
    ];
    exec = "postgres -c 'config_file=/etc/postgresql/postgresql.conf'";
  };
  xdg.configFile."services/main-database/postgresql.conf".text = ''
    # Connectivity
    max_connections = 200
    superuser_reserved_connections = 3
    listen_addresses='*'

    # Memory Settings
    shared_buffers = '4096 MB'
    work_mem = '32 MB'
    maintenance_work_mem = '420 MB'
    huge_pages = off
    effective_cache_size = '11 GB'
    effective_io_concurrency = 1 # concurrent IO only really activated if OS supports posix_fadvise function
    random_page_cost = 4 # speed of random disk access relative to sequential access (1.0)

    # Monitoring
    shared_preload_libraries = 'pg_stat_statements' # per statement resource usage stats
    track_io_timing=on # measure exact block IO times
    track_functions=pl # track execution times of pl-language procedures if any

    # Replication
    wal_level = replica # consider using at least 'replica'
    max_wal_senders = 10
    synchronous_commit = on

    # Checkpointing:
    checkpoint_timeout = '15 min'
    checkpoint_completion_target = 0.9
    max_wal_size = '1024 MB'
    min_wal_size = '512 MB'

    # WAL archiving
    archive_mode = on # having it on enables activating P.I.T.R. at a later time without restart›
    archive_command = '/bin/true' # not doing anything yet with WAL-s


    # WAL writing
    wal_compression = on
    wal_buffers = -1 # auto-tuned by Postgres till maximum of segment size (16MB by default)
    wal_writer_delay = 200ms
    wal_writer_flush_after = 1MB
    wal_keep_size = '3650 MB'


    # Background writer
    bgwriter_delay = 200ms
    bgwriter_lru_maxpages = 100
    bgwriter_lru_multiplier = 2.0
    bgwriter_flush_after = 0

    # Parallel queries:
    max_worker_processes = 8
    max_parallel_workers_per_gather = 4
    max_parallel_maintenance_workers = 4
    max_parallel_workers = 8
    parallel_leader_participation = on

    # Advanced features
    enable_partitionwise_join = on
    enable_partitionwise_aggregate = on
    jit = on
    max_slot_wal_keep_size = '1000 MB'
    track_wal_io_timing = on
    maintenance_io_concurrency = 1
    wal_recycle = on
  '';

  # Caddy ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman.containers.caddy = {
    autoStart = true;
    image = "docker.io/library/caddy";
    network = "server-net";
    ports = [
      "80:80"
      "443:443"
      "443:443/udp"
    ];
    volumes = [
      "${config.home.homeDirectory}/services/data/caddy:/data:Z"
      "${config.home.homeDirectory}/.config/services/Caddy/Caddyfile:/etc/caddy/Caddyfile:Z"
      "${config.home.homeDirectory}/site:/srv/strawmelonjuice-site:ro"
    ];
  };

  programs.zsh.shellAliases.caddy-reload = "podman exec -it caddy caddy reload --config /etc/caddy/Caddyfile";

  xdg.configFile."services/Caddy/Caddyfile".text = ''
                                    {
                                    	email webmaster@strawmelonjuice.com
                                    }

                                    (icon_redirect) {
                                    	redir /assets/site_icon.png https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    	redir /favicon.ico https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    	redir /favicon.png https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    	redir /assets/img/favicon.svg https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    	redir /assets/img/favicon.png https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    	redir /assets/img/site_icon.svg https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    	redir /assets/img/logo.svg https://strawmelonjuice.com/strawmelonjuice.svg permanent
                                    }

                                    git.strawmelonjuice.com {
                                    	redir https://forge.strawmelonjuice.com{uri}
                                    }

                                    forge.strawmelonjuice.com {
                                    	redir /assets/site_icon.png https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
                                    	redir /favicon.ico https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
                                    	redir /favicon.png https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
                                    	redir /assets/img/favicon.svg https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
                                    	redir /assets/img/favicon.png https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
                                    	redir /assets/img/site_icon.svg https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
                                    	redir /assets/img/logo.svg https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent


                                    	# proxy to forgejo
                                    	# reverse_proxy anubis-forge:3000 {
                                    	reverse_proxy forgejo:3000 {
                                    		header_up X-Real-Ip {remote_host}
                                    	}
                                    }

                                    files-shared.strawmelonjuice.com {
                                    	redir https://media.strawmelonjuice.com{uri}
                                    }

                                    fonts.strawmelonjuice.com {
                                    	reverse_proxy 100.65.127.22:39936
                                    }

                                    media.strawmelonjuice.com {
                                    	# request_body {
                                    	#     max_size 3GB
                                    	# }
                                    	reverse_proxy strawmedia:3022
                                    }

                                    cloud.strawmelonjuice.com {
                                    	reverse_proxy owncloud_server:8080
                                    }
                                    matrix.strawmelonjuice.com {
            				reverse_proxy /_matrix/* matrix:8008
    					reverse_proxy /_synapse/client/* matrix:8008
                    			reverse_proxy matrix:8008 {
                				transport http {
                					read_timeout 300s
                					write_timeout 300s
                        			}
                    			}
        				reverse_proxy https://app.cinny.in
                                    }

                                    www.strawmelonjuice.com,
                                    strawmelonjuice.com {
                                    	# Old strawmelonjuice.php and Cynthia Full pages that google is still trying and its annoying me.
                                    	@old_php_pages {
                                    		query p=*
                                    		query c=*
                                    	}

                                    	handle @old_php_pages {
                                    		respond "This content is no longer available." 410
                                    	}
                                    	# ===================------ ATPROTO ------===================
                                    	handle_path /.well-known/atproto-did {
                                    		header Access-Control-Allow-Origin *
                                    		respond "did:plc:jgtfsmv25thfs4zmydtbccnn"
                                    	}

                                    	# ================---- Matrix Homeserver ----================
                                    	handle /.well-known/matrix/* {
                                    		header Access-Control-Allow-Origin *
                                    		header Content-Type application/json

                                    		# Using a Matcher inside the handle to respond differently
                                    		@server path /.well-known/matrix/server
                                    		respond @server `{"m.server": "matrix.strawmelonjuice.com:443"}`

                                    		@client path /.well-known/matrix/client
                                    		respond @client `{"m.homeserver": {"base_url": "https://strawmelonjuice.com"}, "m.identity_server": {"base_url": "https://vector.im"}}`
                                    	}

                                    	handle /_matrix/* {
                                    		reverse_proxy matrix:8008 {
                    					transport http {
                    						read_timeout 300s
                    						write_timeout 300s
                    						dial_timeout 30s
                    					}
                    				}
                                    	}

                                    	handle /_synapse/client/* {
                                    		reverse_proxy matrix:8008
                                    	}

                                    	# ===================------ My Site ------===================
                                    	handle {
                                    		root * /srv/strawmelonjuice-site/
                                    		try_files {path} {path}/index.html /unpopulated.html unpopulated.html
                                    		file_server
                                    	}
                                    }
  '';

  # Owncloud ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Add symlink between Owncloud files <-> Home folders
  home.file."media/music" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/services/data/owncloud/data/files/mar/files/Music";
    force = true;
  };

  systemd.user.services.owncloud = {
    Service = {
      ExecStart = pkgs.writeShellScript "owncloud-starter" ''
        if [ ! -f "${config.xdg.configHome}/services/OwnCloud/.env" ]; then
        	echo "Missing file : ${config.xdg.configHome}/services/OwnCloud/.env"
        	exit 1
        fi
        cd "${config.xdg.configHome}/services/OwnCloud" && podman compose --env-file ./.env --project-name cloud up 
      '';
    };
    Install.WantedBy = [ "default.target" ];
  };

  # Define composefile
  xdg.configFile."services/OwnCloud/docker-compose.yml".text = ''
    networks:
      server-net:
        external: true
      owncloud-net:


    volumes:
      redis:
        driver: local

    services:
      owncloud:
        image: owncloud/server:latest
        container_name: owncloud_server
        depends_on:
          - redis
        environment:
          - OWNCLOUD_DOMAIN=cloud.strawmelonjuice.com
          - OWNCLOUD_TRUSTED_DOMAINS=cloud.strawmelonjuice.com
          - OWNCLOUD_ADMIN_USERNAME=''${OWNCLOUD_ADMIN_USERNAME}
          - OWNCLOUD_ADMIN_PASSWORD=''${OWNCLOUD_ADMIN_PASSWORD}
          - OWNCLOUD_REDIS_ENABLED=true
          - OWNCLOUD_REDIS_HOST=redis
          # Main db
          - OWNCLOUD_DB_TYPE=pgsql 
          - OWNCLOUD_DB_NAME=owncloud
          - OWNCLOUD_DB_USERNAME=owncloud
          - OWNCLOUD_DB_PASSWORD=owncloud
          - OWNCLOUD_DB_HOST=main-database:5432
        healthcheck:
          test: ["CMD", "/usr/bin/healthcheck"]
          interval: 30s
          timeout: 10s
          retries: 5
        volumes:
          - ${config.home.homeDirectory}/services/data/owncloud/data/:/mnt/data:Z
        networks:
          server-net:
            aliases:
              - cloud
          owncloud-net:

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
  '';
  # Forgejo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman.containers.forgejo = {
    autoStart = true;
    autoUpdate = "registry";
    image = "codeberg.org/forgejo/forgejo:16";
    network = "server-net";
    ports = [
      "222:22"
    ];
    environment = {
      "FORGEJO__database__DB_TYPE" = "postgres";
      "FORGEJO__database__HOST" = "main-database:5432";
      "FORGEJO__database__NAME" = "forgejo";
      "FORGEJO__database__USER" = "forgejo";
      "FORGEJO__database__PASSWD" = "forgejo";
      "FORGEJO__DEFAULT__APP_NAME" = "Mar's forge";
      "FORGEJO__DEFAULT__APP_SLOGAN" = "The fruitiest git forge";
      "FORGEJO__server__ROOT_URL" = "https://forge.strawmelonjuice.com";
      "FORGEJO__server__OFFLINE_MODE" = false;
      "FORGEJO__mirror__ENABLED" = true;
    };
    volumes = [
      "${config.home.homeDirectory}/services/data/forgejo:/data:Z"
    ];
  };

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
  };

  # Matrix ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.podman.containers.matrix-main = {
    autoStart = true;
    networkAlias = [
      "matrix"
      "synapse"
    ];
    network = "server-net";
    ports = [
      "8008:8008"
      "8448:8448"
    ];
    image = "matrixdotorg/synapse:sha-5ed830b";
    environment = {
      SYNAPSE_CONFIG_PATH = "/data/homeserver.yaml";
    };
    volumes = [
      "${config.home.homeDirectory}/services/data/matrix/synapse:/data:Z"
    ];
  };
  services.podman.containers.matrix-whatsapp = {
    autoStart = false;
    networkAlias = [ "mautrix-whatsapp" ];
    network = "server-net";
    image = "dock.mau.dev/mautrix/whatsapp:latest";
    volumes = [
      "${config.home.homeDirectory}/services/data/matrix/whatsapp:/data:Z"
    ];
  };
  services.podman.containers.matrix-signal = {
    autoStart = false;
    networkAlias = [ "mautrix-signal" ];
    network = "server-net";
    image = "dock.mau.dev/mautrix/signal:latest";
    volumes = [
      "${config.home.homeDirectory}/services/data/matrix/signal:/data:Z"
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


        echo "Copying local dotfiles..."
        ${pkgs.rsync}/bin/rsync -rlptDX --delete "${config.home.homeDirectory}/.dotfiles/" "$BACKUP_DIR/local_dotfiles/"

        echo "Copying data folder..."
        # sudo cp -r $DATA_DIR $BACKUP_DIR/data_files
        # sudo rm -fr $BACKUP_DIR/data_files/owncloud/data/files/mar/files/Music
        sudo ${pkgs.rsync}/bin/rsync -rlptDX --delete --exclude='owncloud/data/files/mar/files/Music' "$DATA_DIR/" "$BACKUP_DIR/data_files/"
        sudo chown mar:mar -R "$BACKUP_DIR"

        echo "Creating archive..."
        ${pkgs.gnutar}/bin/tar -I 'zstd -1 --threads=0' -cf $FINAL_DEST/$ARCHIVE_NAME -C $BACKUP_DIR .

        echo "Uploading any new or updated music..."
        ${pkgs.rsync}/bin/rsync --bwlimit=4000 -hrvPt --update --size-only ${config.home.homeDirectory}/media/music/ frigometri::music/

        echo "Uploading configs and data..."
        ${pkgs.rsync}/bin/rsync --bwlimit=4000 --partial --progress -avzW $FINAL_DEST/$ARCHIVE_NAME frigometri::backups/
        # ssh frigometri -- tailscale file get --wait /home/mar/backups/ &
        # tailscale file cp $FINAL_DEST/$ARCHIVE_NAME frigometri:

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
