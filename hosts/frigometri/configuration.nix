{
  config,
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    sandbox = false;
  };
  networking.firewall.enable = false;
  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
  };
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  security.pam.services.sshd.allowNullPassword = true;
  services.fstrim.enable = false; # Let Proxmox host handle fstrim
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      PermitEmptyPasswords = "no";
    };
  };
  services.caddy = {
    enable = true;
    virtualHosts = {
      ":9999/ask".extraConfig = ''
          @domain query domain=abc.mar.ollie.earth domain=sharkey.mar.ollie.earth domain=fonts.mar.ollie.earth
          handle @domain {
        	respond 200
          }
          respond 403
      '';
      "http://fonts.mar.ollie.earth".extraConfig = ''
        	header Access-Control-Allow-Origin "*"

        	@options {
        	   method OPTIONS
        	}
        	handle @options {
        	   header Access-Control-Allow-Origin "*"
        	   header Access-Control-Allow-Methods "GET, POST, PUT, PATCH, DELETE, OPTIONS"
        	   header Access-Control-Allow-Headers "*"
        	   header Access-Control-Max-Age "3600"
        	   respond "" 204
        	} 
        	reverse_proxy localhost:39936
      '';
      "http://sharkey.mar.ollie.earth".extraConfig = ''
        	reverse_proxy localhost:39933
      '';
      "http://abc.mar.ollie.earth".extraConfig = ''
        	handle /literally-anything* {
        		respond "somethign else"
        	}
        	respond "goob"
      '';
    };
  };
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      "fonts-proxy" = {
        image = "docker.io/strawmelonjuice/fonts-proxy:1.1.1";
        autoStart = true;
        ports = [
          "39936:8080"
        ];
      };
    };
  };
  services.sharkey = {
    enable = true;
    settings = {
      url = "https://sharkey.mar.ollie.earth/";
      port = 39933;
      address = "127.0.0.1";
    };
    # setupMeilisearch = true;
    setupPostgresql = true;
    setupRedis = true;
  };

  # supress sytemd units that dont work because of lxc
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];
  # Cache DNS lookups to improve performance
  # services.resolved = {
  #   # extraConfig is deprecated. Commented out the entire service for now.
  #   extraConfig = ''
  #     Cache=true
  #     CacheFromLocalhost=true
  #   '';
  # };

  # start tty1 on serial console
  systemd.services."getty@tty1" = {
    enable = true;
    wantedBy = [ "getty.target" ]; # to start at boot
    serviceConfig.Restart = "always"; # restart when session is closed
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --noclear --keep-baud %I 115200,38400,9600 $TERM"
    ];
  };

  services.tailscale.enable = true;

  system.stateVersion = "25.05";

  users.users.mar = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "sudo"
      "docker"
    ];
    uid = 1001;
    subUidRanges = [
      {
        startUid = 165536;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 165536;
        count = 65536;
      }
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN00S7BhcmuvXgGrzIv2dLXGwMxVGL6y164oVAlNIDMf"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyau8tCGMY2+JdzcGw3gav5Ioh59RVBMG22B1z8jn2K"
    ];
  };
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    initdbArgs = [
      "--encoding=UTF-8"
      "--lc-collate=C"
      "--lc-ctype=C"
    ];

    settings = {
      max_connections = 20;
      superuser_reserved_connections = 3;
      shared_buffers = "4096MB";
      work_mem = "32MB";
      maintenance_work_mem = "420MB";
      effective_cache_size = "11GB";
      random_page_cost = 4;
      shared_preload_libraries = "pg_stat_statements";
      track_io_timing = "on";
      wal_level = "replica";
      checkpoint_timeout = "15min";
      checkpoint_completion_target = 0.9;
      max_wal_size = "1024MB";
      archive_mode = "on";
      archive_command = "/bin/true";
    };
  };
  environment.systemPackages = with pkgs; [
    neovim
    git
    podman
    podman-compose
  ];
}
