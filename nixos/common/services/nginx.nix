{ pkgs, lib, config, ... }: {
  options.custom.nginx.enable = lib.mkEnableOption "Enables nginx with sugar";

  config = lib.mkIf config.custom.nginx.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        group = "nginx";
        email = "alwin@stockinger.tech";
        dnsPropagationCheck = true;
        dnsProvider = "cloudflare";
        # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        credentialFiles = {
          "CLOUDFLARE_EMAIL_FILE" = config.sops.secrets.cloudflare_email.path;
          "CLOUDFLARE_API_KEY_FILE" = config.sops.secrets.cloudflare_token.path;
        };
        dnsResolver = "1.1.1.1:53";
        reloadServices = [ "nginx" ];
      };
      certs."stockinger.tech" = { domain = "*.stockinger.tech"; };
    };
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "media.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:8096/";
        };
        "budget.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:5006/";
        };
        "home.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          extraConfig = ''
            proxy_buffering off;
          '';
          locations."/" = {
            proxyPass = "http://alex:8123/";
            proxyWebsockets = true;
          };
        };
        "immich.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:2283/";
        };
        "rss.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          locations."/".proxyPass = "http://bobby:6666/";
        };
        "sabnzbd.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:6336/";
        };
        "sonarr.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:8989/";
        };
        "prowlarr.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:9696/";
        };
        "audiobook.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:9292/";
        };
        "lidarr.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:8686/";
        };
        "radarr.stockinger.tech" = {
          useACMEHost = "stockinger.tech";
          forceSSL = true;
          locations."/".proxyPass = "http://bobby:7878/";
        };
      };
    };
  };
}
