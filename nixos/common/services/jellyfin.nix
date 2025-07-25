{ pkgs, lib, config, ... }: {
  options.custom.jellyfin.enable =
    lib.mkEnableOption "enables video streaming services";

  config = lib.mkIf config.custom.jellyfin.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      #user = "alwin";
      cacheDir = "/data/jellyfin/cache";
      dataDir = "/data/jellyfin/media";
      configDir = "/data/jellyfin/config";
    };

  };
}
