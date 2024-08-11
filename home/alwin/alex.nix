{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./default.nix
  ];

  gpg.enable = true;
  development.enable = false;
}
