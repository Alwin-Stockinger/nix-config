{ pkgs, lib, config, ... }: {
  options.custom.immich.enable = lib.mkEnableOption "Enables immich";

  config = lib.mkIf config.custom.immich.enable {
    services.immich = {
      enable = true;
      openFirewall = true;
      mediaLocation = "/large/photos";
      host = "127.0.0.1";
      port = 2283;
    };
  };
}
