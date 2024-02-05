{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
  ];

  imports = [
    ./common.nix
    ./features/hyprland.nix
  ];
}
