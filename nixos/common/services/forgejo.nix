{ pkgs, lib, config, ... }:
let cfg = config.custom.forgejo;
in {
  options.custom.forgejo = {
    enable = lib.mkEnableOption "Enables forgejo git hosting";
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      settings = {
        server = {
          DOMAIN = "git.stockinger.tech";
          ROOT_URL = "https://git.stockinger.tech/";
          HTTP_PORT = 3001;
          SSH_PORT = lib.head config.services.openssh.ports;
        };
      };
    };

    services.nginx.virtualHosts."git.stockinger.tech" = {
      useACMEHost = "stockinger.tech";
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:3001/";
    };
  };
}
