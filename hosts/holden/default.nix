{
  pkgs,
  lib,
  inputs,
  outputs,
  system,
  ...
}: {
  imports = [
    ../common/darwin.nix
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
}
