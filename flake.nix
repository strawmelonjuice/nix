{
  description = "Mar's dotfiles for nix :3";

  inputs = {
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";

    };

    home-manager = {
      url = "github:nix-community/home-manager";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
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

      # Helper function to create system configs easily
      defineSystem =
        hostname: architecture: is_workstation:
        nixpkgs.lib.nixosSystem {
          system = architecture;
          specialArgs = { inherit inputs hostname; };
          modules = [
            inputs.noctalia.nixosModules.default
            ./hosts/${hostname}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = { inherit inputs hostname; };
              home-manager.users.mar = {
                imports =
                  (
                    if is_workstation then
                      [
                        ./home/desktop.nix
                        ./home/cli.nix
                      ]
                    else
                      [
                        ./home/cli.nix
                      ]
                  )
                  ++ [
                    ./home/host-specific/${hostname}.nix
                  ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        Fennekin = (defineSystem "Fennekin" "x86_64-linux" true);
        Samurott = (defineSystem "Samurott" "x86_64-linux" true);
        Ponyta = (defineSystem "Ponyta" "x86_64-linux" true);
        frigometri = (defineSystem "frigometri" "x86_64-linux" false);
      };
    };
}
