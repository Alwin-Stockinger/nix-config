{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.alejandra.defaultPackage.${system}
    pkgs.zoxide
  ];

  programs.home-manager.enable = true;

  home.username = "alwin";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.homeDirectory = "/var/home/alwin";

  imports = [
    #+./common/desktop.nix
    #./features/vscode.nix
  ];
}
