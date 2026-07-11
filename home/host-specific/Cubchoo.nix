{ pkgs, config, ... }: {
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
  services.caddy = {
    enable = true;
    virtualHosts = {
      # email = "webmaster@strawmelonjuice.com";
      configFile = pkgs.writeText "Caddyfile" ''
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

        knot.strawmelonjuice.com {
        	reverse_proxy tangled:5555
        }

        music.strawmelonjuice.com {
        	reverse_proxy navidrome:4533
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
        		respond "did:plc:jgtfsmv25thfs4zmydtbccnn"
        	}

        	# ================---- Matrix Homeserver ----================
        	handle /.well-known/matrix/* {
        		header Access-Control-Allow-Origin "*"
        		header Content-Type "application/json"

        		# Using a Matcher inside the handle to respond differently
        		@server path /.well-known/matrix/server
        		respond @server `{"m.server": "strawmelonjuice.com:443"}`

        		@client path /.well-known/matrix/client
        		respond @client `{"m.homeserver": {"base_url": "https://strawmelonjuice.com"}}`
        	}

        	handle /_matrix/* {
        		reverse_proxy matrix:8008
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
    };

  };

  # Owncloud ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Add symlink between Owncloud files <-> Home folders
  home.file."media/music" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/services/data/owncloud/data/files/mar/files/Music";
    force = true;
  };

  # Backups ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  systemd.user.services.services-backups = {
    Unit.Description = "Backups";
    Service = {
      ExecStart = pkgs.writeShellScript "backups" ''
        BACKUP_DIR="${config.home.homeDirectory}/backups_temp"
        DATA_DIR="${config.home.homeDirectory}/services/data"
        TIMESTAMP=$(date +"%Y-%m-%d-%H.%M")
        ARCHIVE_NAME="$TIMESTAMP.tar.zst"
        FINAL_DEST="${config.home.homeDirectory}/backups"


        rm -rf $BACKUP_DIR
        mkdir -p $BACKUP_DIR
        mkdir -p $FINAL_DEST

        echo "Dumping database..."
        ${pkgs.podman} exec main-database pg_dumpall -U postgres > $BACKUP_DIR/full_db_backup.sql


        echo "Cloning services repository..."
        git clone --depth 1 --bare https://tangled.org/did:plc:jgtfsmv25thfs4zmydtbccnn/services $BACKUP_DIR/services_repo

        echo "Copying data folder..."
        sudo cp -r $DATA_DIR $BACKUP_DIR/data_files
        sudo rm -fr $BACKUP_DIR/data_files/owncloud/data/files/mar/files/Music
        sudo chown mar:mar -R $BACKUP_DIR

        echo "Creating archive..."
        tar -I 'zstd -1 --threads=0' -cf $FINAL_DEST/$ARCHIVE_NAME -C $BACKUP_DIR .

        echo "Uploading configs and data..."
        # rsync --bwlimit=5000 --partial --progress -avzt $FINAL_DEST/$ARCHIVE_NAME root@mar-backups:${config.home.homeDirectory}/backups/
        tailscale file cp $FINAL_DEST/$ARCHIVE_NAME root@mar-backups:${config.home.homeDirectory}/backups/
        echo "Uploading any new or updated music..."
        rsync --bwlimit=5000  -hrvPt --update ${config.home.homeDirectory}/media/music root@mar-backups:${config.home.homeDirectory}/music

        echo "Cleaning up..."
        rm -rf $BACKUP_DIR

        echo "Backup $ARCHIVE_NAME complete!"
      '';
    };
  };
  # Run every hour
  systemd.user.timers.services-backups = {
    Unit.Description = "Daily backup at half past eleven.";
    Timer = {
      OnCalendar = "*-*-* 23:30:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

}
