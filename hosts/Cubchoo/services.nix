{ pkgs, lib, ... }: {
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      222
      8008
      8776
    ];
    allowedUDPPortRanges = [
      {
        from = 222;
        to = 222;
      }
      {
        from = 4000;
        to = 4007;
      }
      {
        from = 8000;
        to = 8010;
      }
      {
        from = 8700;
        to = 8800;
      }
    ];
  };
  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        "forge.strawmelonjuice.nl" = {
          serverAliases = [ "forge.strawmelonjuice.com" ];
          extraConfig = ''

            	redir /assets/site_icon.png https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
            	redir /favicon.ico https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
            	redir /favicon.png https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
            	redir /assets/img/favicon.svg https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
            	redir /assets/img/favicon.png https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
            	redir /assets/img/site_icon.svg https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent
            	redir /assets/img/logo.svg https://strawmelonjuice.com/svg/forgejo_strawmelonjuice.svg permanent

            	# proxy to forgejo's anubis
            	reverse_proxy localhost:17043 {
            		header_up X-Forwarded-For {client_ip}
            		header_up X-Real-IP {remote_host}
            		header_up X-Http-Version {http.request.proto}
            	}
            	'';
        };
        "cloud.strawmelonjuice.com".extraConfig = "redir https://cloud.strawmelonjuice.nl{uri}";
        "cloud.strawmelonjuice.nl" = {
          extraConfig = ''
            reverse_proxy 0.0.0.0:38080 {
              header_up Host {http.request.host}
              header_up X-Real-IP {http.request.remote.host}
              header_up X-Forwarded-For {http.request.remote.host}
              header_up X-Forwarded-Proto https
            }'';
        };
        "music.strawmelonjuice.nl".extraConfig = "reverse_proxy localhost:4533";
        # Old matrix server, running off of backups on frigometri now
        "https://matrix.strawmelonjuice.com:443" = {
          serverAliases = [ "https://matrix.strawmelonjuice.com:8448" ];
          extraConfig = "reverse_proxy http://frigometri.taild5b3d4.ts.net:18008";
        };
        "fonts.strawmelonjuice.nl" = {
          extraConfig = ''
            header Access-Control-Allow-Origin "*"
            reverse_proxy localhost:39936'';
        };
      };
    };
    anubis = {
      instances = {
        "forgejo" = {
          enable = true;
          settings = {
            TARGET = "http://localhost:7043";
            BIND = ":17043";
            BIND_NETWORK = "tcp";
          };
        };
      };
    };
    # Postgres
    postgresql = {
      # opgeslagen op /var/lib/postgresql/18 want SD is sneller dan de HDD en voor postgres mag dat.
      enable = true;
      package = pkgs.postgresql_18;
      initdbArgs = [
        "--encoding=UTF-8"
        "--lc-collate=C"
        "--lc-ctype=C"
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        # type  database  user      address         auth-method
        local   all       all                       trust
        host    all       all       127.0.0.1/32    scram-sha-256
        host    all       all       ::1/128         scram-sha-256

        # Accepteer ownCloud authenticatie vanaf elk IPv4 netwerkadres
        host    owncloud  owncloud  0.0.0.0/0       scram-sha-256
      '';
      settings = {
        # Connections
        max_connections = 200;
        superuser_reserved_connections = 3;
        listen_addresses = lib.mkForce "*";

        # Memory
        shared_buffers = "4096MB";
        work_mem = "32MB";
        maintenance_work_mem = "420MB";
        huge_pages = "off";
        effective_cache_size = "11GB";
        effective_io_concurrency = 1;
        random_page_cost = 4;

        # Monitoring
        shared_preload_libraries = "pg_stat_statements";
        track_io_timing = "on";
        track_functions = "all";

        # Replication
        wal_level = "replica" # consider using at least 'replica'
        ;
        max_wal_senders = 10;
        synchronous_commit = "on"

        ; # Checkpointing:
        checkpoint_timeout = "15 min";
        checkpoint_completion_target = 0.9;
        max_wal_size = "1024 MB";
        min_wal_size = "512 MB";

        # WAL archiving
        # having it on enables activating P.I.T.R. at a later time without restart
        archive_mode = "on";
        # not doing anything yet with WAL-s
        archive_command = "/bin/true";

        # WAL writing
        wal_compression = "on";
        wal_buffers =
          -1 # auto-tuned by Postgres till maximum of segment size (16MB by default)
        ;
        wal_writer_delay = "200ms";
        wal_writer_flush_after = "1MB";
        wal_keep_size = "3650 MB";

        # Background writer
        bgwriter_delay = "200ms";
        bgwriter_lru_maxpages = 100;
        bgwriter_lru_multiplier = 2.0;
        bgwriter_flush_after = 0;

        # Parallel queries:
        max_worker_processes = 8;
        max_parallel_workers_per_gather = 4;
        max_parallel_maintenance_workers = 4;
        max_parallel_workers = 8;
        parallel_leader_participation = "on";

        # Advanced features
        enable_partitionwise_join = "on";
        enable_partitionwise_aggregate = "on";
        jit = "on";
        max_slot_wal_keep_size = "1000 MB";
        track_wal_io_timing = "on";
        maintenance_io_concurrency = 1;
        wal_recycle = "on";

      };
    };
    forgejo = {
      enable = true;

      package = pkgs.forgejo;

      stateDir = "/cubchoo/forgejo/";
      database = {
        type = "postgres";
        host = "/run/postgresql";
        name = "forgejo";
        user = "forgejo";
      };
      settings = {
        repository = {
          ROOT = lib.mkForce "/cubchoo/forgejo/git/repositories";
        };
        DEFAULT = {
          APP_NAME = "Mar's forge";
          APP_SLOGAN = "The fruitiest git forge";
        };

        server = {
          DOMAIN = "forge.strawmelonjuice.nl";
          ROOT_URL = "https://forge.strawmelonjuice.nl/";
          HTTP_PORT = 7043;
          SSH_PORT = 222;
          OFFLINE_MODE = false;
        };

        mirror = {
          ENABLED = true;
        };
      };
    };
    # Music!
    navidrome = {
      enable = true;
      settings = {
        Scanner.Schedule = "@every 24h";
        MusicFolder = "/cubchoo/owncloud/data/files/mar/files/Music";
        FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
        LastFM.Enabled = false;
        EnableInsightsCollector = true;
      };
      plugins = with pkgs.navidromePlugins; [
        discord-rich-presence
        listenbrainz-daily-playlist
      ];
    };
  };
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      "fonts-proxy" = {
        image = "docker.io/strawmelonjuice/fonts-proxy:1.1.2";
        autoStart = true;
        ports = [
          "39936:8080"
        ];
      };
    };
  };

  # Forgejo
  systemd.services.forgejo.serviceConfig = {
    # Unset me to generate a new (and erroringly read-only) config ini
    ExecStartPre = lib.mkForce [ "" ];
  };

}
