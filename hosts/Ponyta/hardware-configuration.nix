# Edited, make sure to diff it against any future hardware scan outputs
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    open = false;
    nvidiaSettings = true;
    prime = {
	offload.enable = true;
	offload.enableOffloadCmd = true;

	intelBusId = "PCI:0:02.0";
	nvidiaBusId = "PCI:1:00.0";
    };
  };

  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8b092124-3412-49ea-b795-a0bce73d47d5";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E64C-BB1A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
