{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common/desktop.nix
    ./features/hyprland.nix
    ./features/vscode.nix
    ./features/gpg
  ];
}
