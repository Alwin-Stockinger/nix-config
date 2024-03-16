{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common/common.nix
    ./features/vscode.nix
    ./features/gpg
  ];
}
