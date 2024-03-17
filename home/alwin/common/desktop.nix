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

  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };

  home.packages = with pkgs; [
    pkgs.nixops_unstable
    unstable.vlc
  ];
}
