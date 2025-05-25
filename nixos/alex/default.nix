{ config, pkgs, lib, inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ../common ];

  custom = {
    virt.enable = true;
    arr.enable = true;
  };

  # For remote deployment
  nix.settings.trusted-users = [ "sudo" "alwin" ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      wireless = { sopsFile = ../../secrets.yaml; };
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
      bobby_pub_key = {
        sopsFile = ../../secrets.yaml;
        neededForUsers = true;
      };
    };
  };

  users.users.alwin = {
    #hashedPasswordFile = config.sops.secrets.password.path;
    #openssh.authorizedKeys.keyFiles = [ config.sops.secrets.bobby_pub_key.path ]; does not work because file is read at build time https://discourse.nixos.org/t/can-how-do-you-manage-ssh-authorized-keys-with-sops-nix/46467
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
    interfaces.end0.ipv4.addresses = [{
      address = "192.168.1.30";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
    firewall = { allowedTCPPorts = [ 80 443 ]; };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      group = "nginx";
      email = "alwin@stockinger.tech";
      dnsPropagationCheck = true;
      dnsProvider = "cloudflare";
      #      server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      credentialFiles = {
        "CLOUDFLARE_EMAIL_FILE" = config.sops.secrets.cloudflare_email.path;
        "CLOUDFLARE_API_KEY_FILE" = config.sops.secrets.cloudflare_token.path;
      };
      dnsResolver = "1.1.1.1:53";
      reloadServices = [ "nginx" ];
    };
    certs."stockinger.tech" = { domain = "*.stockinger.tech"; };
  };

  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "media.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:8096/";
        };
        "budget.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:5006/";
        };
        "home.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          extraConfig = ''
            proxy_buffering off;
          '';
          locations."/" = {
            proxyPass = "http://127.0.0.1:8123/";
            proxyWebsockets = true;
          };
        };
        "immich.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:2283/";
        };
        "rss.stockinger.tech" = {
          acmeRoot = null;
          enableACME = true;
          addSSL = true;
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

    home-assistant = {
      enable = true;
      extraComponents = [ "esphome" "met" "radio_browser" "denonavr" "hue" ];
      customComponents = with pkgs.home-assistant-custom-components;
        [ epex_spot ];
      configDir = "/data/hass-config";
      config = {
        default_config = { };
        "automation ui" = "!include automations.yaml";
        "script ui" = "!include scripts.yaml";
        http = {
          server_host = "127.0.0.1";
          trusted_proxies = [ "127.0.0.1" ];
          use_x_forwarded_for = true;
        };
      };
    };

    postgresql = { dataDir = "/data/postgresql"; };
    postgresqlBackup = {
      enable = true;
      backupAll = true;
      location = "/data/backup";
    };

    immich = {
      enable = true;
      openFirewall = true;
      mediaLocation = "/data/immich";
      host = "127.0.0.1";
      port = 2283;
    };

    tt-rss = {
      enable = true;
      # to configure a nginx virtual host directly:
      selfUrlPath = "https://rss.stockinger.tech";
      virtualHost = "rss.stockinger.tech";
      registration.enable = true;
    };
  };

  environment.systemPackages =
    [ pkgs.jellyfin-web pkgs.jellyfin-ffmpeg pkgs.mergerfs ];

  virtualisation.oci-containers.containers.actual = {
    image = " ghcr.io/actualbudget/actual-server:25.4.0-alpine";
    ports = [ "0.0.0.0:5006:5006" ];
    volumes = [ "/data/actual/data:/data" ];
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
