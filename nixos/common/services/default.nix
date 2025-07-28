{ inputs, outputs, lib, config, pkgs, system, ... }: {

  imports = [ ./arr ./jellyfin.nix ./immich.nix ];
}
