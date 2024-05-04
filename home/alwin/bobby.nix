{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./default.nix
  ];

  desktop.enable = true;
}
