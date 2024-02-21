{
  config,
  pkgs,
  inputs,
  ...
}: {


  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
  };

  programs.gpg = {
    enable = true;
  };

  home.packages = with pkgs; [
    firefox
    vesktop
    pinentry-curses # for gpg
  ];

  imports = [
    ./common.nix
    ./features/hyprland.nix
  ];
}
