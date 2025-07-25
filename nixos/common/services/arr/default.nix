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
      stateDir = "/data/media/.state/nixarr";

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
        whitelistHostnames = [ "alex" "bobby" "sabnzbd.stockinger.tech" ];
      };
    };
  };
}
