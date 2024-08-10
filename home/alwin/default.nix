{ config
, pkgs
, inputs
, outputs
, lib
, ...
}:
let
  cfg = config.custom;
  zsh-theme = builtins.toFile "work.zsh-theme" "
        PROMPT=\"%{$fg_bold[cyan]%}%c%{$reset_color%}\"
        PROMPT+=' $(kube_ps1) '
        #PROMPT+=' $(git_prompt_info)'


        ZSH_THEME_GIT_PROMPT_PREFIX=\"%{$fg_bold[blue]%}git:(%{$fg[red]%}\"
        ZSH_THEME_GIT_PROMPT_SUFFIX=\"%{$reset_color%} \"
        ZSH_THEME_GIT_PROMPT_DIRTY=\"%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}\"
        ZSH_THEME_GIT_PROMPT_CLEAN=\"%{$fg[blue]%})\"
        KUBE_PS1_PREFIX=\"(\"
        KUBE_PS1_SUFFIX=\")\"
        KUBE_PS1_SYMBOL_DEFAULT=\"\"
        KUBE_PS1_CTX_COLOR=\"red\"
        KUBE_PS1_NS_COLOR=\"red\"
        KUBE_PS1_BG_COLOR=\"\"
        KUBE_PS1_DIVIDER=''
        KUBE_PS1_SEPARATOR=''
        KUBE_PS1_NS_ENABLE=false";
  min-packages = with pkgs; [
    inputs.alejandra.defaultPackage.${system}
    git-extras
  ];
  standard-packages = with pkgs; [
    neofetch
    tldr
    bat
    sops
    yq-go
    dig
    htop
    ripgrep # for neovim telescope
  ];
in
{
  options = {
    custom.work = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    home = {
      packages =
        min-packages
        ++ (
          if cfg.work
          then [ ]
          else standard-packages
        );
    };
    programs = {
      atuin = {
        enable = true;
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      git = {
        enable = true;
        userName = "Alwin";
        userEmail = "alwin@stockinger.tech";
        extraConfig = {
          rebase.autostash = true;
          pull = {
            rebase = true;
          };
          push = {
            autoSetupRemote = true;
          };
        };
      };

      gh = {
        enable = ! config.custom.work;
      };

      alacritty = {
        enable = true;
        catppuccin.enable = true;
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      #      overlays = [
      #        outputs.overlays.unstable-packages
      #      ];
    };

    home.username = "alwin";
    home.stateVersion = "24.05";

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;

      initExtra = "
  path+=('/run/current-system/sw/bin/')
  path+=('/Applications/Visual Studio Code.app/Contents/Resources/app/bin')
  path+=('/etc/profiles/per-user/alwin/bin')
  path+=('/var/home/alwin/.cargo/bin')
  eval \"$(zoxide init zsh)\"
  if [ -n \"\${commands[fzf-share]}\" ]; then
    source \"$(fzf-share)/key-bindings.zsh\"
    source \"$(fzf-share)/completion.zsh\"
  fi
  terminal=$(basename \"/\"$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat | cut -d \\  -f 4) | tail -1 | sed 's/ .*$//'))
  if [[ $terminal == \"kitty\" ]]; then
    echo \"kitten detected\"
    alias ssh=\"kitten ssh\"
  fi
  if [[ $WORK == \"true\" ]]; then
    export PATH=\"\${KREW_ROOT:-$HOME/.krew}/bin:$PATH\"
    echo \"work detected\"
    . <(flux completion zsh)
    source <(kubectl completion zsh)
    complete -C '/usr/bin/aws_completer' aws
    source <(pulumi completion zsh)
    source <(helm completion zsh)
  fi
  hash hyprlock=/usr/local/bin/hyprlock
      ";

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "kube-ps1"
        ];
        theme =
          if cfg.work
          then "work"
          else "aussiegeek";
        custom = zsh-theme;
      };

      shellAliases = {
        cat = "bat";
        cd = "z";

        switch = "git switch";
        pull = "git pull";
        git-link = "gh browse $(git rev-parse HEAD) -n";

        ts = "tailscale";
      };
    };

    programs.helix = {
      enable = true;
      defaultEditor = false;
      languages = {
        language = [
          {
            name = "nix";
            indent = {
              tab-width = 2;
              unit = " ";
            };
            auto-format = true;
            formatter = {
              command = "alejandra";
            };
          }
        ];
      };
      settings = {
        editor = {
          line-number = "relative";
        };
      };
    };
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      keymaps = [
        {
          mode = "n";
          key = "<leader>ff";
          action = "<cmd>Telescope find_files<CR>";
        }
        {
          mode = "n";
          key = "<leader>fg";
          action = "<cmd>Telescope live_grep<CR>";
        }
        {
          mode = "n";
          key = "<leader>fb";
          action = "<cmd>Telescope buffers<CR>";
        }
        {
          mode = "n";
          key = "<leader>fh";
          action = "<cmd>Telescope help_tags<CR>";
        }
      ];

      opts = {
        number = true;
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
        relativenumber = true;
      };

      colorschemes.catppuccin.enable = true;

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

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin
    ./features/desktop.nix
    ./features/development.nix
    ./features/gpg
  ];
}
