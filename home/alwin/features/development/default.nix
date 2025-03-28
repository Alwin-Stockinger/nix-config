{ config
, pkgs
, inputs
, outputs
, lib
, ...
}: {
  imports = [
    ./nvim.nix
  ];

  options.development = {
    enable = lib.mkEnableOption "enables development stuff";
  };

  config = lib.mkIf config.development.enable {
    nixpkgs = {
      overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];
    };

    home.packages = with pkgs; [
      kubectl
      inputs.alejandra.defaultPackage.${system}
      fzf
      jq
      direnv
      nil
      grpcurl
      iperf3
      golangci-lint
      #texlive.combined.scheme-full
      taskwarrior3
      jc
      ripgrep # for neovim telescope
      eza
      cargo
      go
    ];

    catppuccin = {
      enable = true;
      ghostty.enable = true;
    };

    home = {
      shell.enableNushellIntegration = true;
    };

    programs = {
      zellij = {
        enable = true;
        enableZshIntegration = true;
      };
      atuin = {
        enable = true;
        settings = {
          # Dont clear screen
          style = "full";
          inline_height = 0;
        };
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      ghostty = {
        enable = true;
        package = null; #currently marked as broken
        enableZshIntegration = true;
        settings = {
          theme = "catppuccin-mocha";
        };
      };
      kitty = {
        enable = true;
        themeFile = "Catppuccin-Mocha";
        settings = {
          enable_audio_bell = false;
        };
      };
      yazi.enable = true;

      nushell.enable = true;

      starship = {
        enable = true;
        settings = {
          format = "$directory\\([$kubernetes](red)\\): ";
          kubernetes = {
            disabled = false;
            format = "$context";
          };
        };
      };

      carapace = {
        enable = true;
      };
    };

    programs.vscode = {
      enable = !config.custom.work;
      profiles.default.userSettings = {
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
            "fileMatch" = [ "*.hujson" ];
            "schema" = {
              "allowTrailingCommas" = true;
            };
          }
        ];
        "nix.enableLanguageServer" = true; # Enable LSP.
        "nix.serverPath" = "nil"; # The path to the LSP server executable.

        "go.lintTool" = "golangci-lint";
        "go.lintFlags" = [
          "--fast"
        ];

        "[yaml]"."editor.defaultFormatter" = "redhat.vscode-yaml";
        "workbench.tree.indent" = 12;
        "workbench.tree.renderIndentGuides" = "always";
        "workbench.colorCustomizations" = {
          "tree.indentGuidesStroke" = "#ffffff";
          "sideBar.foreground" = "#ffffff";
        };
        "window.restoreFullscreen" = true;
        "window.newWindowDimensions" = "maximized";
      };
      profiles.default.extensions = with pkgs.vscode-marketplace; [
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
        kennylong.kubernetes-yaml-formatter
      ];
    };
  };
}
