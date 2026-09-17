{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./services.nix
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    inputs.nixos-hardware.nixosModules.raspberry-pi-5
  ];

  nixpkgs = {
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
    config = {
      permittedInsecurePackages = [
      ];

      allowUnfree = true;
      packageOverrides = pkgs: {
        stable = import <nixpkgs-stable> {
          config = config.nixpkgs.config;
        };
      };
    };
  };
  nix = {
    package = lib.mkForce pkgs.lixPackageSets.stable.lix;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking.hostName = "Cubchoo";
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.enable = true;
  networking.wireless = {
    enable = true;
    extraConfig = "country=NL";
  };
  hardware.firmware = [ pkgs.wireless-regdb ];
  services.tailscale.enable = true;

  time.timeZone = "Europe/Amsterdam";
  boot = {
    supportedFilesystems = {
      ext4 = true;
      vfat = true;
      zfs = lib.mkForce false;
    };
    # boot.initrd.includeDefaultModules = lib.mkForce false;
    initrd.allowMissingModules = true;
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 70;
    };
    initrd.availableKernelModules.dw-hdmi = lib.mkForce false;
  };
  hardware.raspberry-pi = {
    firmware = {
      enable = true;
      uboot.enable = true;
    };

    configtxt.settings = {
      all = {
        dtparam = [
          "audio=on"
          "i2c_arm=on"
        ];
        dtoverlay = [
          "vc4-kms-v3d"
          "disable-bt"
        ];
        arm_boost = true;
      };
      pi5.arm_freq = 2400;
    };
  };

  fileSystems."/cubchoo" = {
    device = "/dev/disk/by-label/cubchoo-data";
    fsType = "ext4";
    options = [
      "users"
      "nofail"
      "exec"
      "noatime"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    micro
  ];
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  users.users.mar = {
    isNormalUser = true;
    description = "MLC Bloeiman";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "sudo"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN00S7BhcmuvXgGrzIv2dLXGwMxVGL6y164oVAlNIDMf"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyau8tCGMY2+JdzcGw3gav5Ioh59RVBMG22B1z8jn2K"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKYFw1Pr1q/PXBRwBz9h0wiV4I4xjPd0BgzptTLECZDqAAAABHNzaDo= mar@strawmelonjuice.com's Yubikey 5C 1"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBKmawcg4EArqnBiDPZhqHas8qm4R3n6f5wtoLKdowd4YQA6oQnTHKQ0ReKWZw/aMSoUgR5nuuMZObPy6bsdQS10AAAAEc3NoOg== mar@Samurott Yubikey 1"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoQBb5B3iDgdRb+rFwK1t3C6nDW9JTpDGvATnxdTVXZ Backup server management key"
    ];
  };
  programs.fish.enable = true;
  services.openssh = {
    enable = true;
  };

  programs.mosh.enable = true;
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

  # Set a password on the image generated with `nix build .#nixosConfigurations.Cubchoo.config.system.build.sdImage`.
  users.users.root.initialPassword = "nixos";
  sdImage.compressImage = false;

  system.stateVersion = "26.05";
}
