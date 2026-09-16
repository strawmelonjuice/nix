{
  pkgs,
  lib,
  config,
  ...
}:
{

  fileSystems."/var/lib/nextcloud/data" = {
    device = "/cubchoo/nextcloud/data";
    fsType = "none";
    options = [ "bind" ];
  };
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
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
      }
    }/nextcloud-extras.nix"
  ];

  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        # My site
        "strawmelonjuice.nl".extraConfig = ''
            handle_path /.well-known/atproto-did {
          		header Access-Control-Allow-Origin *
          		respond "did:plc:jgtfsmv25thfs4zmydtbccnn"
          	}

          	# un-anubised traffic
          	reverse_proxy /svg/* localhost:7008

          	# proxy through anubis
          	reverse_proxy anubis:3000 {
          		header_up X-Forwarded-For {client_ip}
          		header_up X-Real-IP {client_ip}
          		header_up X-Http-Version {http.request.proto}
          	}
            reverse_proxy localhost:17044 {
          		header_up X-Forwarded-For {client_ip}
          		header_up X-Real-IP {remote_host}
          		header_up X-Http-Version {http.request.proto}
          	}
        '';

        "http://strawmelonjuice.nl:7044".extraConfig = ''
            #  My Site
          	root * /cubchoo/site-files/
          	try_files {path} {path}/index.html /unpopulated.html unpopulated.html
          	file_server
        '';

        # Forgejo
        "forge.strawmelonjuice.com".extraConfig = "redir https://forge.strawmelonjuice.nl{uri}";
        "forge.strawmelonjuice.nl" = {
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
        # Nextcloud
        "cloud.strawmelonjuice.nl" = {
          serverAliases = [
            "cloud.strawmelonjuice.com"
          ];
          extraConfig = "redir https://nextcloud.strawmelonjuice.nl{uri}";
        };
        "http://${config.services.nextcloud.hostName}" = {
          serverAliases = [
            "${config.services.nextcloud.hostName}"
            # And for whiteboard
            "http://localhost:40603"
          ];
        };

        "nextcloud.strawmelonjuice.nl/whiteboard*".extraConfig = ''
          uri strip_prefix /whiteboard
          reverse_proxy localhost:3002'';

        # Media
        "media.strawmelonjuice.nl".extraConfig = "reverse_proxy localhost:3022";
        # Navidrome
        "music.strawmelonjuice.nl".extraConfig = "reverse_proxy localhost:4533";
        # Old matrix server, running off of backups on frigometri now
        "https://matrix.strawmelonjuice.com:443" = {
          serverAliases = [ "https://matrix.strawmelonjuice.com:8448" ];
          extraConfig = "reverse_proxy http://frigometri.taild5b3d4.ts.net:18008";
        };
        # Public Google Fonts proxy
        "fonts.strawmelonjuice.nl" = {
          extraConfig = ''
            header Access-Control-Allow-Origin "*"
            reverse_proxy localhost:39936'';
        };

        # Radicle Explorer
        "rad.strawmelonjuice.nl" = {
          extraConfig = ''
            	    root * ${
                   pkgs.radicle-explorer.withConfig {
                     preferredSeeds = [
                       {
                         hostname = "seed.strawmelonjuice.nl";
                         port = 443;
                         scheme = "https";
                       }

                     ];
                   }
                 }
            	    try_files {path} /
            	    file_server
          '';
        };
        "seed.strawmelonjuice.nl".extraConfig = "reverse_proxy localhost:7065";
      };
    };
    radicle = {
      # checkConfig = false;
      enable = true;

      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyau8tCGMY2+JdzcGw3gav5Ioh59RVBMG22B1z8jn2K";
      privateKey = "/home/mar/.radicle/keys/radicle";

      httpd = {
        enable = true;
        nginx.serverName = "seed.strawmelonjuice.nl";
        listenPort = 7065;
        aliases = {
          Lumina = "rad:z3KozhW4C7ykQoe65DX8yUUGEHcdA";
          "strawmelonjuice.nl" = "rad:z3tXbjDQGe7hWmCzmTMQWCPDtJhdP";
        };

      };

      # Seeding node
      node = {
        listenAddress = "[::0]";
        openFirewall = true;
      };

      settings = {
        preferredSeeds = config.home-manager.mar.programs.radicle.settings.preferredSeeds;
        node = {
          alias = "strawmelonjuice";
          follow = [
            "z6MkqWHpFf8SoFQxJQPRw4xvKYrXTcUkRTzaeFio352xwYiA@samurott:8776"
            "z6MkjEcgs2bLEYMQDDSrCjVxzcZens5D3vFz9AxhyHbSjSo9@fennekin:8776"
            "z6MkozXoRQG2zosyFTGSmtxbxqj1y4sdBevhnsAQH6xbJQxz@ponyta:8776"

            "z6MkqWHpFf8SoFQxJQPRw4xvKYrXTcUkRTzaeFio352xwYiA@samurott:8776"
            "z6MkjEcgs2bLEYMQDDSrCjVxzcZens5D3vFz9AxhyHbSjSo9@fennekin:8776"
            "z6MkozXoRQG2zosyFTGSmtxbxqj1y4sdBevhnsAQH6xbJQxz@ponyta:8776"
          ];
          seeds = [
            "rad:z3KozhW4C7ykQoe65DX8yUUGEHcdA" # Lumina
            "rad:z2udif7tkxDuczay6MbLhDnDoyMDB" # fonts-proxy
            "rad:z3tXbjDQGe7hWmCzmTMQWCPDtJhdP" # Homepage
            "rad:zF4ocfML4MryiqMDDX77R5HSKspr" # Dotfiles
            "rad:z35nCKGbfQEpKWuuD75vCQpM33sMQ" # Sweetnhouse
            "rad:z2HErp1NnCWvC8imVvpmEw8oxUGCt" # Chilp
          ];

          externalAddresses = [ "strawmelonjuice.nl:8776" ];

          seedingPolicy = {
            default = "block";
            scope = "followed";
          };
        };
        web = {
          description = "The fruitiest Radicle node";
          pinned.repositories = [
            # Which repositories to pin
            "rad:z3KozhW4C7ykQoe65DX8yUUGEHcdA" # Lumina
            "rad:z3tXbjDQGe7hWmCzmTMQWCPDtJhdP" # Homepage
            "rad:zF4ocfML4MryiqMDDX77R5HSKspr" # Dotfiles
          ];
        };
      };
    };
    anubis = {
      instances = {
        "my-site" = {
          enable = true;
          settings = {
            TARGET = "http://localhost:7044";
            BIND = ":17044";
            BIND_NETWORK = "tcp";
          };
        };
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
    # NextCloud
    nextcloud = {
      enable = true;
      webserver = "caddy";
      package = pkgs.nextcloud34;
      imaginary.enable = true;
      home = "/var/lib/nextcloud";
      datadir = "/var/lib/nextcloud";
      # datadir = "/cubchoo/nextcloud";
      # This breaks apps! So instead I made a bind volume between /var/lib/nextcloud/data and /cubchoo/nextcloud/data/
      hostName = "nextcloud.strawmelonjuice.nl";
      maxUploadSize = "2G";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          news
          contacts
          calendar
          tasks
          whiteboard
          # richdocuments
          ;
      };
      extraAppsEnable = false;
      appstoreEnable = true;
      config = {
        # Postgres trust-based auth doesn't work, so deciding to use SQLite
        dbtype = "sqlite";
        adminpassFile = "/etc/nextcloud-admin-pass";
        adminuser = "mar";
      };
      settings = {
        preview_format = "webp";
        maintenance_window_start = 1;
        mail_domain = "strawmelonjuice.nl";
        # overwriteprotocol = "https";
        default_phone_region = "NL";
        log_type = "systemd";
        serverid = 0;
      };
    };
    nextcloud-whiteboard-server = {
      enable = true;
      settings = {
        NEXTCLOUD_URL = "http://localhost:40603";
      };
      secrets = [ "/etc/nextcloud-whiteboard-secret" ];
    };

    # Music!
    navidrome = {
      enable = true;
      settings = {
        Scanner.Schedule = "@every 24h";
        MusicFolder = "/cubchoo/music";
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
        autoStart = true;
        image = "docker.io/strawmelonjuice/fonts-proxy:1.1.2";
        ports = [
          "39936:8080"
        ];
      };
      mediajuice = {
        autoStart = true;
        image = "docker.io/strawmelonjuice/strawmediajuice:1.2.1";
        ports = [
          "3022:3000"
        ];
        volumes = [
          "/cubchoo/strawmediajuice:/app/data:Z"
        ];

      };
    };
  };

  # Forgejo
  systemd.services.forgejo.serviceConfig = {
    # Unset me to generate a new (and erroringly read-only) config ini
    ExecStartPre = lib.mkForce [ "" ];
  };
  # Backups
  systemd.services.services-backups = {
    description = "Backups";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      MemoryHigh = "4G";
      MemoryMax = "6G";
      ExecStart = pkgs.writeShellScript "backups" ''
        echo "Streaming deduplicated snapshot to Frigometri..."
        ${pkgs.restic}/bin/restic -r sftp:frigometri:/home/mar/backups backup --insecure-no-password \
          "/cubchoo" \
          "/home/mar/.dotfiles" \
          "/var/lib/postgresql" \
          "/var/lib/navidrome" \
          "/var/lib/nextcloud" \
          "/var/lib/radicle"
        echo "Pruning old snapshots..."
        ${pkgs.restic}/bin/restic -r sftp:frigometri:/home/mar/backups forget --keep-daily 7 --keep-weekly 4 --prune --insecure-no-password

        echo "Collecting music"
        mkdir -p /cubchoo/music
        mkdir -p /cubchoo/music/mar
        mkdir -p /cubchoo/music/lily

        ${pkgs.rsync}/bin/rsync -hrvPt --update --size-only /cubchoo/nextcloud/data/mar/files/Music/* /cubchoo/music/mar
        # ${pkgs.rsync}/bin/rsync -hrvPt --update --size-only /cubchoo/nextcloud/data/lily/files/Music/* /cubchoo/music/mar

        chmod a+rwx -R /cubchoo/music/

        echo "Uploading new music to Frigometri..."
        ${pkgs.rsync}/bin/rsync --bwlimit=400 -hrvPt --update --size-only /cubchoo/music frigometri::music/
      '';
    };
  };
  systemd.timers.services-backups = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 23:30:00";
      Persistent = true;
    };
  };
}
