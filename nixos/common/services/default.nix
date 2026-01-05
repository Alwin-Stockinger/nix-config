{ inputs, outputs, lib, config, pkgs, system, ... }: {

  imports = [
    ./arr
    ./immich.nix
    ./postgres.nix
    ./budget.nix
    ./nginx.nix
    ./home-assistant.nix
    ./miniflux.nix
    ./grafana.nix
  ];
}
