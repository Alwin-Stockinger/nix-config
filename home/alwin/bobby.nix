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
    unstable.vlc
    handbrake
  ];

  imports = [
    ./default.nix
  ];

  desktop.enable = true;
  gpg.enable = true;
}
