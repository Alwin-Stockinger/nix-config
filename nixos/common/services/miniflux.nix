{ pkgs, lib, config, ... }:
let cfg = config.custom.miniflux;
in {
  options.custom.miniflux = {
    enable = lib.mkEnableOption "Enables miniflux RSS reader";
  };

  config = lib.mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.secrets.miniflux_admin.path;
    };

    services.nginx.virtualHosts."rss.stockinger.tech" = {
      useACMEHost = "stockinger.tech";
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8080/";
    };
  };
}
