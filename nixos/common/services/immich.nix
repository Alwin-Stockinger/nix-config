{ pkgs, lib, config, ... }: {
  options.custom.immich.enable = lib.mkEnableOption "Enables immich";

  config = lib.mkIf config.custom.immich.enable {
    services.immich = {
      enable = true;
      openFirewall = true;
      mediaLocation = "/large/photos";
      host = "0.0.0.0";
      port = 2283;
    };
  };
}
