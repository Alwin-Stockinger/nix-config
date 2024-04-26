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
  nixpkgs.hostPlatform = "x86_64-darwin";
}
