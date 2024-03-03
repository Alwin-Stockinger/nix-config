{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    pkgs.nixops_unstable
  ];
}
