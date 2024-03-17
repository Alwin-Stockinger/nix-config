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
    unstable.vlc
  ];

  imports = [
    ./common/desktop.nix
    ./features/hyprland.nix
    ./features/vscode.nix
    ./features/gpg
  ];
}
