{
  description = "Mar's dotfiles for nix :3";

  inputs = {
    nixpkgs-2605 = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    rad-portable.url = "git+https://seed.strawmelonjuice.nl/z2nwKQD8V1bhozD9ZiZi8SGifbYmx.git";
    # ./home/modules/niri/noctalia.nix is not in use.
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # ./home/modules/librewolf.nix is not in use.
    # firefox-addons = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    puppy-toetaps = {
      url = "git+https://forge.strawmelonjuice.nl/lillianrose/citrine.git?rev=af460c22980f6c276762aa9de36ca1fb0bd195d1";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-instant.url = "github:Mic92/direnv-instant";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-2605,
      home-manager,
      ...
    }@inputs:
    let
      nixpkgsConfig = {
        permittedInsecurePackages = [
          # I don't have private repositories
          "radicle-node-1.10.3"
        ];
        allowUnfree = true;
      };

      nixpkgsOverlays = [
        (final: prev: {
          stable = import nixpkgs-2605 {
            system = prev.stdenv.hostPlatform.system;
            config = {
              allowUnfree = true;
            };
          };
          inherit (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = nixpkgsConfig;
          overlays = nixpkgsOverlays;
        };

      # This config truly applies to all systems.
      globalNixOsConfig =
        { pkgs, ... }:
        {
          nixpkgs = {
            config = nixpkgsConfig;
            overlays = nixpkgsOverlays;
          };
          nix = {
            package = nixpkgs.lib.mkForce pkgs.lixPackageSets.stable.lix;
            settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
            gc = {
              automatic = true;
              dates = "daily";
              options = "--delete-older-than 7d";
            };
            settings.auto-optimise-store = true;
          };
          boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
          environment = {
            systemPackages = with pkgs; [
              jj
              # coreutils
              uutils-coreutils-noprefix
              git
            ];
            shellInit = ''
              export GPG_TTY=$(tty)
            '';

            pathsToLink = [
              "/share/zsh"
              "/share/fish"
            ];
          };
          services.tailscale.enable = true;
          users.users = {
            mar = {
              isNormalUser = true;
              description = "MLC Bloeiman";
              openssh.authorizedKeys.keys = [
                "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJcIWHOpK3xwuCkqhqw+sTh++lVF2xLa4szixk81TWYRAAAAHHNzaDpzc2hfc3RyYXdtZWxvbmp1aWNlX21haW4= ssh:ssh_strawmelonjuice_main"
                "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJkLyzUpgECLzHslD8Bj0pSM9Mkqq7xam6c9XswlEmicAAAAIXNzaDpzc2hfc3RyYXdtZWxvbmp1aWNlX2JhY2t1cF8xRA== ssh:ssh_strawmelonjuice_backup_1D"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN00S7BhcmuvXgGrzIv2dLXGwMxVGL6y164oVAlNIDMf"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyau8tCGMY2+JdzcGw3gav5Ioh59RVBMG22B1z8jn2K"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoQBb5B3iDgdRb+rFwK1t3C6nDW9JTpDGvATnxdTVXZ Backup server management key"
              ];
              shell = pkgs.fish;
              extraGroups = [
                "networkmanager"
                "wheel"
              ];
              packages = with pkgs; [
                obsidian
                moonlight-qt
                yubioath-flutter
                vlc
              ];
            };
          };
          programs = {
            fish.enable = true;
            nix-ld.enable = true;
            nix-ld.libraries = with pkgs; [
              # Add any missing dynamic libraries for unpackaged programs
              # here, NOT in environment.systemPackages
              gcc
            ];
            mosh.enable = true;
          };
          security = {
            doas.enable = true;
            sudo.enable = false;
            doas.extraRules = [
              {
                users = [
                  "mar"
                  "root"
                ];
                keepEnv = true;
                persist = true;
              }
            ];
          };
        };

      # Helper function to get home modules
      getHomeModules =
        configName: hostname:
        if configName == "hostname" || configName == "default" then
          [
            # System brings it's own mixture of configs.
            ./systems/configurations/${hostname}/hm.nix
          ]
        else
          [
            # A mixture has been selected:
            ./home-manager/configurations/${configName}.nix
          ]
          # And the system can tweak it if needed:
          ++ nixpkgs.lib.optional (builtins.pathExists ./systems/configurations/${hostname}/hm.nix) ./systems/configurations/${hostname}/hm.nix;

      # Helper function to create system configs easily
      defineSystem =
        {
          HMconfigName,
          hostName,
          architecture,
        }:
        let
          hostname = hostName;
        in
        nixpkgs.lib.nixosSystem {
          system = architecture;
          specialArgs = { inherit inputs hostname; };

          modules = [
            ./systems/configurations/${hostname}/system.nix
            globalNixOsConfig
          ]
          ++ nixpkgs.lib.optionals (HMconfigName != "disable") [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs hostname; };
              home-manager.users.mar.imports = getHomeModules HMconfigName hostname;
            }
          ];
        };

      # Helper function for standalone Home Manager
      defineHome =
        {
          configName,
          hostName,
          architecture,
        }:
        let
          hostname = hostName;
          pkgs = mkPkgs architecture;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs hostname; };
          modules = getHomeModules configName hostname;
        };
    in
    {
      nixosConfigurations = {
        Fennekin = (
          defineSystem {
            hostName = "Fennekin";
            architecture = "x86_64-linux";
            HMconfigName = "workstation";
          }
        );
        Samurott = (
          defineSystem {
            hostName = "Samurott";
            architecture = "x86_64-linux";
            HMconfigName = "workstation";
          }
        );
        Ponyta = (
          defineSystem {
            hostName = "Ponyta";
            architecture = "x86_64-linux";
            HMconfigName = "workstation";
          }
        );
        frigometri = (
          defineSystem {
            hostName = "frigometri";
            architecture = "x86_64-linux";
            HMconfigName = "default";
          }
        );
        Tepig = (
          defineSystem {
            hostName = "Tepig";
            architecture = "x86_64-linux";
            HMconfigName = "workstation";
          }
        );
        Cubchoo = (
          defineSystem {
            hostName = "Cubchoo";
            architecture = "aarch64-linux";
            HMconfigName = "default";
          }
        );
      };

      homeConfigurations = {
        Fennekin = (
          defineHome {
            hostName = "Fennekin";
            architecture = "x86_64-linux";
            configName = "workstation";
          }
        );
        Samurott = (
          defineHome {
            hostName = "Samurott";
            architecture = "x86_64-linux";
            configName = "workstation";
          }
        );
        Ponyta = (
          defineHome {
            hostName = "Ponyta";
            architecture = "x86_64-linux";
            configName = "workstation";
          }
        );
        frigometri = (
          defineHome {
            hostName = "frigometri";
            architecture = "x86_64-linux";
            configName = "default";
          }
        );
        Cubchoo = (
          defineHome {
            hostName = "Cubchoo";
            architecture = "aarch64-linux";
            configName = "default";
          }
        );
        Tepig = (
          defineHome {
            hostName = "Tepig";
            architecture = "x86_64-linux";
            configName = "workstation";
          }
        );

        Samurott-win = (
          defineHome {
            hostName = "Samurott-win";
            architecture = "x86_64-linux";
            configName = "wsl";
          }
        );
        Ponyta-win = (
          defineHome {
            hostName = "Ponyta-win";
            architecture = "x86_64-linux";
            configName = "wsl";
          }
        );
      };
    };
}
