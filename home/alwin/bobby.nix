{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
    vesktop
    wl-clipboard
  ];

  imports = [
    ./common/desktop.nix
    ./features/hyprland.nix
    ./features/vscode.nix
    ./features/gpg
  ];
}
