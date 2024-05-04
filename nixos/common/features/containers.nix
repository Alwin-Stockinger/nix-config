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

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        #dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
