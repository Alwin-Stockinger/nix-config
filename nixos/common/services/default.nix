{ inputs, outputs, lib, config, pkgs, system, ... }: {

  imports = [ ./arr ./immich.nix ./postgres.nix ];
}
