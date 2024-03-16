{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
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
    hostName = "alex";
    wireless = {
      enable = true;
      environmentFile = config.sops.secrets.wireless.path;
      networks."TCL-25KR".psk = "@TCL25KR@";
      interfaces = ["wlan0"];
    };
    interfaces.wlan0.ipv4.addresses = [
      {
        address = "192.168.1.30";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = ["192.168.1.1"];
    firewall = {
      allowedTCPPorts = [80 443 8096];
    };
  };

  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users."alwin" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = ["wheel" "docker"];
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

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
