{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
    vesktop
  ];

  imports = [
    ./common.nix
    ./features/hyprland.nix
  ];
}
