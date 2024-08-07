{ config
, pkgs
, inputs
, lib
, outputs
, ...
}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
      inputs.nixgl.overlay
    ];
  };

  home.packages = with pkgs; [
    nixgl.nixGLIntel
    trivy
  ];

  programs.atuin = {
    enable = true;
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts = {
      number = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
    };

    colorschemes.gruvbox.enable = true;

    plugins = {
      lualine.enable = true;

      lsp = {
        enable = true;

        servers = {
          yamlls.enable = true;
          tsserver.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };

          snippet.expand = ''
                 function(args)
            require('luasnip').lsp_expand(args.body)
                 end
          '';

          sources = [
            { name = "nvim_lsp"; }
            { name = "clippy"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
        };
      };
      bufferline.enable = true;
      cmp-buffer = {
        enable = true; # Enable suggestions for buffer in current file
      };
      cmp-path = {
        enable = true; # Enable suggestions for file system paths
      };
      cmp_luasnip = {
        enable = true; # Enable suggestions for code snippets
      };
      cmp-cmdline = {
        enable = false; # Enable autocomplete for command line
      };
      telescope.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
      lsp-format.enable = true;

      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          code_actions = {
            gitrebase.enable = true;
            gitsigns.enable = true;
            statix.enable = true;
            refactoring.enable = true;
            ts_node_action.enable = true;
          };
          completion = {
            spell.enable = true;

          };
          diagnostics = {
            actionlint.enable = true;
            buf.enable = true;
            checkmake.enable = true;
            checkstyle.enable = true;
            statix.enable = true;
            codespell.enable = true;
            staticcheck.enable = true;
            markdownlint.enable = true;
            sqlfluff.enable = true;
            zsh.enable = true;
          };
          formatting = {
            nixpkgs_fmt.enable = true;
            black = {
              enable = true;
            };
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            stylua.enable = true;
            alejandra.enable = true;
          };
        };
      };
    };
  };

  home.homeDirectory = "/var/home/alwin";

  programs.git = {
    userEmail = lib.mkForce "alwin.stockinger@powerbot-trading.com";
  };

  #systemd.user.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.zsh = {
    oh-my-zsh.custom = lib.mkForce "$HOME/nix-config/home/alwin/work/zsh";
    oh-my-zsh.theme = lib.mkForce "work";
    shellAliases = {
      ll = "ls -l";
      k = "kubectl";
      kustomize = "kubectl kustomize";
      ctx = "kubectx";
      ex-machina = "kubectx ex-machina";
      dev = "kubectx dev";
      b64 = "base64";
      rec-git = "flux reconcile source git flux-system";
      pus = "pulumi up --suppress-outputs --stack";
      pcg = "pulumi config get --stack";
      pcs = "pulumi config set --stack";

      pr = "gh pr create -a @me -r samox73,SoMuchForSubtlety";
      pr-sam = "gh pr create -a @me -r samox73";
      pr-pasha = "gh pr create -a @me -r pmikh";
      pr-jakob = "gh pr create -a @me -r SoMuchForSubtlety";

      git-link = "gh browse $(git rev-parse HEAD) -n";
      cat = "bat";
      pods = "kubectl get pods -o wide";
      switch = "git switch";
      ts = "tailscale";
      code-nix = "code ~/nix-config";
      code-flux = "code ~/powerbot/flux-powerbot";
      tardis = "code ~/powerbot/tardis";
    };

    localVariables = {
      WORK = "true";
    };
  };

  programs.k9s = {
    enable = true;
    views = {
      "v1/jobs" = {
        columns = [
          "NAME"
          "AGE"
          "STATUS"
        ];
      };
    };
  };

  imports = [
    ../default.nix
  ];

  desktop.enable = true;
  desktop.waybarMonitor = "eDP-1";
  desktop.monitors = [ "eDP-1, 1920x1200, 0x0, 1" ];
  custom.work = true;
}
