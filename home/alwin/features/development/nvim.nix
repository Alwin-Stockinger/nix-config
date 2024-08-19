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
          key = "<C-k>";
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

        # Gitsigns
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>gh";
          action = "gitsigns";
          options = {
            silent = true;
            desc = "+hunks";
          };
        }
        {
          mode = "n";
          key = "<leader>ghb";
          action = ":Gitsigns blame_line<CR>";
          options = {
            silent = true;
            desc = "Blame line";
          };
        }
        {
          mode = "n";
          key = "<leader>ghd";
          action = ":Gitsigns diffthis<CR>";
          options = {
            silent = true;
            desc = "Diff This";
          };
        }
        {
          mode = "n";
          key = "<leader>ghR";
          action = ":Gitsigns reset_buffer<CR>";
          options = {
            silent = true;
            desc = "Reset Buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>ghS";
          action = ":Gitsigns stage_buffer<CR>";
          options = {
            silent = true;
            desc = "Stage Buffer";
          };
        }
      ];

      opts = {
        number = true;
        relativenumber = true;

        tabstop = 2;
        showtabline = 2;
        expandtab = true;

        smartindent = true;
        shiftwidth = 2;

        breakindent = true; # https://stackoverflow.com/questions/1204149/smart-wrap-in-vim

        ignorecase = true;
        smartcase = true;
        grepprg = "rg --vimgrep";
        grepformat = "%f:%l:%c:%m";

        # Set completeopt to have a better completion experience
        completeopt = [
          "menuone"
          "noselect"
          "noinsert"
        ]; # mostly just for cmp

        # Enable persistent undo history
        swapfile = false;
        backup = false;
        undofile = true;

        # Enable 24-bit colors
        termguicolors = true;

        scrolloff = 8; # Always keep 8 lines above/below cursor unless at start/end of file

        # Set encoding type
        encoding = "utf-8";
        fileencoding = "utf-8";
      };

      colorschemes.catppuccin.enable = true;

      plugins = {
        lualine.enable = true;
        markdown-preview.enable = true;
        trouble.enable = true;
        bufferline.enable = true;
        telescope.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        luasnip.enable = true;
        lsp-format.enable = true;

        gitsigns = {
          enable = true;
          settings = {
            trouble = true;
            current_line_blame = true;
            signs = {
              add = {
                text = "│";
              };
              change = {
                text = "│";
              };
              delete = {
                text = "_";
              };
              topdelete = {
                text = "‾";
              };
              changedelete = {
                text = "~";
              };
              untracked = {
                text = "│";
              };
            };
          };
        };

        lsp = {
          enable = true;

          keymaps = {
            silent = true;
            lspBuf = {
              gd = {
                action = "definition";
                desc = "Goto Definition";
              };
              gr = {
                action = "references";
                desc = "Goto References";
              };
              gD = {
                action = "declaration";
                desc = "Goto Declaration";
              };
              gI = {
                action = "implementation";
                desc = "Goto Implementation";
              };
              gT = {
                action = "type_definition";
                desc = "Type Definition";
              };
              K = {
                action = "hover";
                desc = "Hover";
              };
              "<leader>cw" = {
                action = "workspace_symbol";
                desc = "Workspace Symbol";
              };
              "<leader>cr" = {
                action = "rename";
                desc = "Rename";
              };
            };
            diagnostic = {
              "<leader>cd" = {
                action = "open_float";
                desc = "Line Diagnostics";
              };
              "[d" = {
                action = "goto_next";
                desc = "Next Diagnostic";
              };
              "]d" = {
                action = "goto_prev";
                desc = "Previous Diagnostic";
              };
            };
          };

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
