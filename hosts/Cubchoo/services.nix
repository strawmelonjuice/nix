{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./services/radicle-proxy.nix
    ./services/caddy.nix
    "${
      fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
      }
    }/nextcloud-extras.nix"
  ];
  fileSystems = {

    "/var/lib/nextcloud/data" = {
      device = "/cubchoo/nextcloud/data";
      fsType = "none";
      options = [ "bind" ];
    };
    "/var/lib/radicle" = {
      device = "/cubchoo/radicle";
      fsType = "none";
      options = [ "bind" ];
    };

  };

  services = {
    radicle = {
      # checkConfig = false;
      enable = true;

      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyau8tCGMY2+JdzcGw3gav5Ioh59RVBMG22B1z8jn2K";
      privateKey = "/home/mar/.ssh/id_ed25519-radicle";

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
        preferredSeeds = (import ../../other/radicle-nodes.nix).all;
        node = {
          alias = "strawmelonjuice";
          follow = [
            "z6MkqWHpFf8SoFQxJQPRw4xvKYrXTcUkRTzaeFio352xwYiA@samurott:8776"
            "z6MkjEcgs2bLEYMQDDSrCjVxzcZens5D3vFz9AxhyHbSjSo9@fennekin:8776"
            "z6MkozXoRQG2zosyFTGSmtxbxqj1y4sdBevhnsAQH6xbJQxz@ponyta:8776"

          ];
          seeds = [
            "rad:z3KozhW4C7ykQoe65DX8yUUGEHcdA" # Lumina
            "rad:z2udif7tkxDuczay6MbLhDnDoyMDB" # fonts-proxy
            "rad:z3tXbjDQGe7hWmCzmTMQWCPDtJhdP" # Homepage
            "rad:z3gXgvgtCPVevRbiNgAMvrHbCswhn" # Dotfiles
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
            "rad:z3gXgvgtCPVevRbiNgAMvrHbCswhn" # Dotfiles
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
          SSH_SERVER_USE_PROXY_PROTOCOL = false;
          SSH_PORT = 443;
          SSH_LISTEN_PORT = 2240;
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
        ${pkgs.restic}/bin/restic -r sftp:mar@frigometri:/home/mar/backups backup --insecure-no-password \
          "/cubchoo" \
          "/home/mar/.dotfiles" \
          "/var/lib/postgresql" \
          "/var/lib/navidrome" \
          "/var/lib/nextcloud/config" \
          "/var/lib/nextcloud/store-apps" \
          -e "/cubchoo/nextcloud/data/*/files/Music/"
        echo "Pruning old snapshots..."
        ${pkgs.restic}/bin/restic -r sftp:mar@frigometri:/home/mar/backups forget --keep-daily 7 --keep-weekly 4 --prune --insecure-no-password

        echo "Collecting music"
        mkdir -p /cubchoo/music/mar
        mkdir -p /cubchoo/music/lily

        ${pkgs.rsync}/bin/rsync -hrvPt --update --size-only /cubchoo/nextcloud/data/mar/files/Music/* /cubchoo/music/mar/
        ${pkgs.rsync}/bin/rsync -hrvPt --update --size-only /cubchoo/nextcloud/data/Lily/files/Music/* /cubchoo/music/lily/

        chmod a+rwx -R /cubchoo/music/

        echo "Uploading new music to Frigometri..."
        ${pkgs.rsync}/bin/rsync --bwlimit=400 -hrvPt --update --size-only /cubchoo/music/ frigometri::music/
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
  systemd.services.radicle-node = {
    path = [ pkgs.openssh ];
    confinement.enable = lib.mkForce false;
    serviceConfig = {
      MemoryHigh = "600M";
      MemoryMax = "1G";
      CPUQuota = "85%";
      CPUWeight = 20;
      IOWeight = 20;
      User = lib.mkForce "mar";
      Group = lib.mkForce "users";
      ProtectHome = lib.mkForce false;
    };
  };
  systemd.services.radicle-httpd = {
    path = [ pkgs.openssh ];
    confinement.enable = lib.mkForce false;
    serviceConfig = {
      User = lib.mkForce "mar";
      Group = lib.mkForce "users";
    };
  };

}
