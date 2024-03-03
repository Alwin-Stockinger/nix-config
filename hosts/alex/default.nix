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

  sops = {
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.wireless = {
      sopsFile = ./secrets.yaml;
    };
    secrets.password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
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
    "/data" = {
      device = "/dev/disk/by-uuid/af40487f-a450-4412-b7cb-7af1f44b1026";
      fsType = "ext4";
      options = ["nofail"];
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

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      #dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        data-root = "/data/docker";
      };
    };
  };
  users.users.alwin.extraGroups = ["docker"];

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
