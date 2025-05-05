{ pkgs, lib, config, ... }:
let cfg = config.custom.arr;
in {
  options.custom.arr = {
    enable = lib.mkEnableOption "enables container services (docker, podman)";
  };

  config = lib.mkIf cfg.enable {
    nixarr = {
      enable = true;
      mediaDir = "/data/media";
      stateDir = "/data/nixarr/.state/nixarr";

      sonarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      sabnzbd = {
        enable = true;
        openFirewall = true;
        whitelistHostnames = [ "alex" "sabnzbd.stockinger.tech" ];
      };
    };

    services = {
      nginx = {
        virtualHosts = {
          "sabnzbd.stockinger.tech" = {
            acmeRoot = null;
            enableACME = true;
            addSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:8080/";
          };
          "sonarr.stockinger.tech" = {
            acmeRoot = null;
            enableACME = true;
            addSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:8989/";
          };
          "prowlarr.stockinger.tech" = {
            acmeRoot = null;
            enableACME = true;
            addSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:9696/";
          };
        };
      };
    };
  };
}
