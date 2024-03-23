{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
    unstable.vesktop #stable is broken atm https://github.com/NixOS/nixpkgs/issues/293083
    wl-clipboard
    makemkv
    unstable.vlc
    handbrake
  ];

  imports = [
    ./common/desktop.nix
    ./features/hyprland.nix
    ./features/vscode.nix
    ./features/gpg
  ];
}
