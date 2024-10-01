{ config
, pkgs
, lib
, inputs
, ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ../common/default.nix
    #"${inputs.nixpkgs-unstable}/nixos/modules/services/misc/jellyfin.nix"
  ];
  #  disabledModules = [ "services/misc/jellyfin.nix" ];
  virt.enable = true;

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      wireless = {
        sopsFile = ../../secrets.yaml;
      };
      password = {
        sopsFile = ../../secrets.yaml;
        neededForUsers = true;
      };
      cloudflare_token = {
        sopsFile = ../../secrets.yaml;
        neededForUsers = true;
      };
      cloudflare_email = {
        sopsFile = ../../secrets.yaml;
        neededForUsers = true;
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/data" = {
      device = "/dev/disk/by-uuid/af40487f-a450-4412-b7cb-7af1f44b1026";
      fsType = "ext4";
      options = [ "nofail" ];
    };
  };

  networking = {
    hostName = "alex";
    #    wireless = {
    #      enable = true;
    #      environmentFile = config.sops.secrets.wireless.path;
    #      networks."TCL-25KR".psk = "@TCL25KR@";
    #      interfaces = ["wlan0"];
    #   };
    interfaces.end0.ipv4.addresses = [
      {
        address = "192.168.1.30";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
    firewall = {
      allowedTCPPorts = [ 80 443 ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "alwin@stockinger.tech";
      dnsPropagationCheck = true;
      dnsProvider = "cloudflare";
      #      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      credentialFiles = {
        "CLOUDFLARE_EMAIL_FILE" = config.sops.secrets.cloudflare_email.path;
        "CLOUDFLARE_API_KEY_FILE" = config.sops.secrets.cloudflare_token.path;
      };
      reloadServices = [ "nginx" ];
    };
    certs."stockinger.tech" = {
      domain = "*.stockinger.tech";
      dnsResolver = "1.1.1.1:53";
      extraDomainNames = [ "*.stockinger.tech" ];
    };
  };

  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "media.stockinger.tech" = {
          acmeRoot = null;
          enableACME = true;
          addSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:8096/";
        };
        "budget.stockinger.tech" = {
          acmeRoot = null;
          enableACME = true;
          addSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:5006/";
        };
        "home.stockinger.tech" = {
          acmeRoot = null;
          enableACME = true;
          addSSL = true;
          extraConfig = ''
            proxy_buffering off;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:8123/";
            proxyWebsockets = true;
          };
        };
        "sonarr.stockinger.tech" = {
          acmeRoot = null;
          enableACME = true;
          addSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8989/";
          };
        };
      };
    };

    openssh.enable = true;

    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "alwin";
      cacheDir = "/data/jellyfin/cache";
      dataDir = "/data/media";
      configDir = "/data/jellyfin/config";
    };

    sonarr = {
      enable = true;
      user = "alwin";
      dataDir = "/data/sonarr/data";
      openFirewall = true;
    };

    transmission = {
	enable = true;
	user = "alwin";
};

    home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
        "denonavr"
        "hue"
      ];
      customComponents = with pkgs.home-assistant-custom-components; [
        epex_spot
      ];
      config = {
        default_config = { };

        http = {
          server_host = "127.0 .0 .1";
          trusted_proxies = [ "127.0 .0 .1" ];
          use_x_forwarded_for = true;
        };
      };
    };
  };

  environment.systemPackages = [
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  virtualisation.oci-containers.containers.actual = {
    image = " ghcr.io/actualbudget/actual-server:24.8.0-alpine";
    ports = [ "0.0.0.0:5006:5006" ];
    volumes = [
      "/data/actual/data:/data"
    ];
  };

  # virtualisation = {
  #   podman = {
  #     enable = true;

  #     # Create a `docker` alias for podman, to use it as a drop-in replacement
  #     #dockerCompat = true;

  #     # Required for containers under podman-compose to be able to talk to each other.
  #     defaultNetwork.settings.dns_enabled = true;
  #   };

  #   docker = {
  #     enable = true;
  #     rootless = {
  #       enable = true;
  #       setSocketVariable = true;
  #     };
  #     daemon.settings = {
  #       data-root = "/data/docker";
  #     };
  #   };
  # };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
