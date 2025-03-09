{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./default.nix
  ];
  development.enable = true;

  home.homeDirectory = "/Users/alwin";
}
