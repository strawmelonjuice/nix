{ config, pkgs, ... }: {
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
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/mholt/caddy-l4@v0.1.2" ];
      hash = "sha256-C+ksbA6ucY3GUsYHSUhkYoh1gTP8SIAJv0MLjhX8BQM=";
    };
    globalConfig = ''
      servers {
        listener_wrappers {
          layer4 {
            # Check traffic for ssh and route it to port 2240 if it matches
            @ssh ssh
            route @ssh {
              proxy localhost:2240
            }
            route
          }
          tls
        }
      }
    '';
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
        reverse_proxy localhost:17044 {
          header_up X-Forwarded-For {client_ip}
          header_up X-Real-IP {remote_host}
          header_up X-Http-Version {http.request.proto}
        }'';

      "http://localhost:7044" = {
        serverAliases = [ "http://strawmelonjuice.nl:7044" ];
        extraConfig = ''
          #  My Site
          root * /cubchoo/site-files/
          try_files {path} {path}/index.html /unpopulated.html unpopulated.html
          file_server'';
      };

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
}
