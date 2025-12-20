{ pkgs, lib, config, ... }: {
  options.custom.budget.enable =
    lib.mkEnableOption "Enables actual budget application";

  config = lib.mkIf config.custom.budget.enable {

    # TODO the dataDir is not configurable for this, but it should be pretty easy to do so https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/actual.nix
    # services.actual = {
    #   enable = true;
    #   openFirewall = true;
    #   settings.port = 5006;
    # };

    virtualisation.oci-containers.containers.actual = {
      image = "ghcr.io/actualbudget/actual-server:25.12.0-alpine";
      ports = [ "0.0.0.0:5006:5006" ];
      volumes = [ "/data/actual-budget/data:/data" ];
    };
  };
}
