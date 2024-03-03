{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
  };

  programs.vscode = {
    enable = true;
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
    ];
  };
}
