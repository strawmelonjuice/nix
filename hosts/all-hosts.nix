{
  lib,
  pkgs,
  config,
  ...
}:
{

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

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
  nix.package = lib.mkForce pkgs.lixPackageSets.stable.lix;

  nixpkgs.config = {
    permittedInsecurePackages = [
      # I don't have private repositories
      "radicle-node-1.10.3"
    ];

    joypixels.acceptLicense = true;

    allowUnfree = true;
    packageOverrides = pkgs: {
      stable = import <nixpkgs-stable> {
        config = config.nixpkgs.config;
      };
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  environment = {
    pathsToLink = [
      "/share/zsh"
      "/share/fish"
    ];
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

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    gcc
  ];

  services.tailscale.enable = true;
  services.radicle.node.openFirewall = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # programs.ssh.startAgent = false;

  environment.shellInit = ''
    export GPG_TTY=$(tty)
  '';

  # Enable fish
  programs.fish.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable niri and KDE. I like to be able to switch whenever.
  programs.niri.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = lib.mkForce "niri";

  # Switching to SDDM after hopping around a lot; will we hate this?
  # SDDM/KDE Login manager just refuse to start... plasma. GDM then?
  services.displayManager.gdm = {
    enable = true;
    autoSuspend = true;
    banner = "Property of MLC Bloeiman.\n\nHai :3\n";
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    konversation
    kpat # Solitaire
    ksudoku
    discover
    ktorrent
    merkuro
    kontact
    ktnef
    kdepim-runtime
    korganizer

  ];

  # services.desktopManager.cosmic.enable = true;
  # services.system76-scheduler.enable = true;
  # environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  # environment.sessionVariables.XDG_CURRENT_DESKTOP = "cosmic";
  # environment.cosmic.excludePackages = with pkgs; [
  #   cosmic-edit
  #   cosmic-store
  # ];

  # Keep nix store to a reasonable size
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  # User account
  users.users.mar = {
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
      thunderbird
      obsidian
      moonlight-qt
    ];
  };
  # Force usage of OO7 for secrets
  services.oo7.enable = true;
  security.pam.services.mar.oo7.enable = true;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  security.pam.services.login.kwallet.enable = lib.mkForce false;
  security.pam.services.kdewallet.enable = lib.mkForce false;

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
