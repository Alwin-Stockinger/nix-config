{
  config,
  pkgs,
  inputs,
  lib,
  outputs,
  ...
}: {
  home.homeDirectory = "/var/home/alwin";

  programs.git = {
    userEmail = lib.mkForce "alwin.stockinger@powerbot-trading.com";
  };

  programs.zsh = {
    oh-my-zsh.custom = lib.mkForce "$HOME/nix-config/home/alwin/work/zsh";
    oh-my-zsh.theme = lib.mkForce "work";

    localVariables = {
      WORK = "true";
    };
  };

  imports = [
    ../common/desktop.nix
    ../features/vscode.nix
    ../features/hyprland.nix
  ];
}
