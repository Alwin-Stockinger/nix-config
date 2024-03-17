{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    pkgs.nixops_unstable
  ];
}
