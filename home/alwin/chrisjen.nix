{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common/desktop.nix
    ./features/vscode.nix
  ];
}
