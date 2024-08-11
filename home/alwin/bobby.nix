{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
    wl-clipboard
    makemkv
    vlc
    handbrake
  ];

  imports = [
    ./default.nix
  ];

  desktop.enable = true;
  gpg.enable = true;
  development.enable = true;
}
