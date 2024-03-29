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
      "window.zoomLevel" = 0.4;
      "workbench.colorTheme" = "Default Dark Modern";
      "editor.minimap.enabled" = false;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSaveMode" = "file";

      "terminal.integrated.scrollback" = 100000;

      "githubPullRequests.pullBranch" = "never";

      "[helm]"."editor.formatOnSave" = false;
      "[python]"."editor.defaultFormatter" = "ms-python.black-formatter";

      "diffEditor.ignoreTrimWhitespace" = false;

      "vs-kubernetes"."vs-kubernetes.crd-code-completion" = "enabled";
      "files.exclude"."**/.git" = false;
      "files.associations" = {
        "*.hujson" = "jsonc";
      };
      "json.schemas" = [
        {
          "fileMatch" = ["*.hujson"];
          "schema" = {
            "allowTrailingCommas" = true;
          };
        }
      ];
    };
    extensions = with pkgs.vscode-marketplace; [
      kamadorueda.alejandra
      ms-python.black-formatter
      fabiospampinato.vscode-diff
      ms-azuretools.vscode-docker
      ms-python.flake8
      github.vscode-github-actions
      github.vscode-pull-request-github
      eamodio.gitlens
      golang.go
      ms-kubernetes-tools.vscode-kubernetes-tools
      bierner.markdown-mermaid
      jnoortheen.nix-ide
      esbenp.prettier-vscode
      ms-python.vscode-pylance
      ms-python.python
      ms-python.debugpy
      timonwong.shellcheck
      redhat.vscode-yaml
      hilleer.yaml-plus-json
      tailscale.vscode-tailscale
    ];
  };
}
