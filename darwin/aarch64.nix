{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./common.nix
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
}
