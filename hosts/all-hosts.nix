{
  lib,
  pkgs,
  config,
  ...
}:
{

  nixpkgs.overlays = [
    (final: prev: {
      inherit (prev.lixPackageSets.stable)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];
  nix.package = pkgs.lixPackageSets.stable.lix;

  nixpkgs.config = {
    permittedInsecurePackages = [
    ];

    joypixels.acceptLicense = true;

    allowUnfree = true;
    packageOverrides = pkgs: {
      stable = import <nixpkgs-stable> {
        config = config.nixpkgs.config;
      };
    };
  };
  environment = {

    pathsToLink = [ "/share/zsh" ];
    variables = {
      GTK_IM_MODULE = lib.mkForce null;
      QT_IM_MODULE = lib.mkForce null;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    yubioath-flutter
    pinentry-qt
    git
    gnupg
    jj
    podman-compose
    podman-tui
    polkit_gnome
    wayland-utils
    wl-clipboard
    xclip
    xwayland-satellite
    # coreutils
    uutils-coreutils-noprefix
    git
    vlc

    # KDE Utilities
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kclock
    kdePackages.kcolorchooser
    kdePackages.ksystemlog
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
  ];
  services.gnome.gnome-online-accounts.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    gcc
  ];

  services.tailscale.enable = true;

  # Enable zsh
  programs.zsh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment, Niri and Cosmic. I like to be able to switch whenever.
  # services.displayManager.cosmic-greeter.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa # We got strawberry
    kdePackages.kdepim-runtime
    kdePackages.konversation # IRC client
    kdePackages.kpat # Solitaire
    kdePackages.ksudoku
    kdePackages.ktorrent
  ];

  programs.niri.enable = true;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  security.pam.services.lightdm.kwallet.enable = true;
  security.pam.services.login.kwallet.enable = true;

  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  environment.sessionVariables.XDG_CURRENT_DESKTOP = "cosmic";
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-store
  ];
  # services.desktopManager.plasma6.enable = true;

  # Keep nix store to a reasonable size
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 13d";
  };
  nix.settings.auto-optimise-store = true;

  # User account
  users.users.mar = {
    isNormalUser = true;
    description = "MLC Bloeiman";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      thunderbird
      obsidian
      moonlight-qt
    ];
  };
  programs.mosh.enable = true;
  security.pam.services.hyprlock = { };
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = [
        "mar"
        "root"
      ];
      keepEnv = true;
      noPass = true;
    }
  ];

}
