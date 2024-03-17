{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
      outputs.overlays.unstable-packages
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    userSettings = {
      "window.titleBarStyle" = "custom";
      "window.zoomLevel" = 1;
      "editor.formatOnSave" = true;
      "editor.formatOnSaveMode" = "file";
    };
    extensions = with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide
      ms-python.black-formatter
      kamadorueda.alejandra
      tailscale.vscode-tailscale
    ];
  };
}
