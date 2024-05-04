{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    virt.enable = lib.mkEnableOption "enables container services (docker, podman)";

    # podman = true;
    # docker = true;
  };

  config = lib.mkIf config.virt.enable {
    virtualisation = {
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      docker = {
        enable = true;
      };
    };
  };
}
