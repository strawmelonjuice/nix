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
      home-manager,
      ...
    }@inputs:
    let

      # Helper function to get home modules
      getHomeModules =
        hostname: is_workstation:
        (
          if is_workstation then
            [
              ./home/desktop.nix
              ./home/default.nix
            ]
          else
            [
              ./home/default.nix
            ]
        )
        ++ [
          ./home/host-specific/${hostname}.nix
        ];

      # Helper function to create system configs easily
      defineSystem =
        hostname: architecture: is_workstation:
        nixpkgs.lib.nixosSystem {
          system = architecture;
          specialArgs = { inherit inputs hostname; };
          modules = [
            # inputs.noctalia.nixosModules.default
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit inputs hostname;
              };
              home-manager.users.mar = {
                imports = getHomeModules hostname is_workstation;

              };
            }
          ];
        };

      # Helper function for standalone Home Manager
      defineHome =
        hostname: architecture: is_workstation:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            overlays = [
              (final: prev: {
                inherit (prev.lixPackageSets.stable)
                  nixpkgs-review
                  nix-eval-jobs
                  nix-fast-build
                  colmena
                  ;
              })
            ];

            system = architecture;
            config = {
              nix.package = nixpkgs.lixPackageSets.stable.lix;
              nix.settings = {
                experimental-features = "flakes nix-command";
              };
              allowUnfreePackages = [
                "joypixels"
              ];
              joypixels.acceptLicense = true;
              allowUnfree = true;
              permittedInsecurePackages = [
                "radicle-node-1.10.3"
              ];
            };

          };
          extraSpecialArgs = { inherit inputs hostname; };
          modules = getHomeModules hostname is_workstation;
        };
    in
    {
      nixosConfigurations = {
        Fennekin = (defineSystem "Fennekin" "x86_64-linux" true);
        Samurott = (defineSystem "Samurott" "x86_64-linux" true);
        Ponyta = (defineSystem "Ponyta" "x86_64-linux" true);
        frigometri = (defineSystem "frigometri" "x86_64-linux" false);
        Tepig = (defineSystem "Tepig" "x86_64-linux" true);
        Cubchoo = (defineSystem "Cubchoo" "aarch64-linux" false);
      };

      homeConfigurations = {
        Fennekin = (defineHome "Fennekin" "x86_64-linux" true);
        Samurott = (defineHome "Samurott" "x86_64-linux" true);
        Ponyta = (defineHome "Ponyta" "x86_64-linux" true);
        frigometri = (defineHome "frigometri" "x86_64-linux" false);
        Cubchoo = (defineHome "Cubchoo" "aarch64-linux" false);
        Tepig = (defineHome "Tepig" "x86_64-linux" true);
      };
    };
}
