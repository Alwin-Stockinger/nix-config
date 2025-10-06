{ pkgs, lib, config, ... }: {
  options.custom.home-assistant.enable =
    lib.mkEnableOption "Enables home-assistant";

  config = lib.mkIf config.custom.home-assistant.enable {
    services.home-assistant = {
      enable = true;
      extraComponents =
        [ "esphome" "met" "radio_browser" "denonavr" "hue" "recorder" ];
      customComponents = with pkgs.home-assistant-custom-components;
        [ epex_spot ];
      configDir = "/data/hass-config";
      config = {
        default_config = { };
        "automation ui" = "!include automations.yaml";
        "script ui" = "!include scripts.yaml";
        http = {
          trusted_proxies = [ "127.0.0.1" ];
          use_x_forwarded_for = true;
        };
        recorder = { "db_url" = "postgresql://@/home"; };
      };
    };
  };
}
