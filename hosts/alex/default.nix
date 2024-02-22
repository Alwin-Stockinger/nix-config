{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  SSID = "TCL-25KR";
  interface = "wlan0";
  hostname = "alex";
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../common/nixos.nix
  ];

  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

  sops.secrets.wireless = {
    sopsFile = ./secrets.yaml;
  };

  sops.secrets.password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      environmentFile = config.sops.secrets.wireless.path;
      networks."${SSID}".psk = "@TCL25KR@";
      interfaces = [interface];
    };
  };

  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users."alwin" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = ["wheel"];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
