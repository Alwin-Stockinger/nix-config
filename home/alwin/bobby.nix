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
    makemkv
  ];

  imports = [
    ./common/desktop.nix
    ./features/hyprland.nix
    ./features/vscode.nix
    ./features/gpg
  ];
}
