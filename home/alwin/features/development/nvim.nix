{ config
, pkgs
, inputs
, outputs
, lib
, ...
}: {
  config = lib.mkIf config.development.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      keymaps = [
        # switch splits

        {
          mode = "n";
          key = "<C-l>";
          action = "<C-W>l";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-W>h";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-W>j";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-W>k";
          options.silent = true;
        }

        # Telescope
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
  };
}
