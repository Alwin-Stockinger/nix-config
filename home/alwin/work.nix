{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.alejandra.defaultPackage.${system}
    pkgs.unstable.zoxide
  ];

  imports = [
    #+./common/desktop.nix
    #./features/vscode.nix
  ];
}
