{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common
    ./features/vscode.nix
  ];
}
