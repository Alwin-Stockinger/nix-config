{ config, pkgs, inputs, outputs, lib, system, ... }: {

  options.custom.development = {
    enable = lib.mkEnableOption "enables helix editor";
  };

  config = lib.mkIf config.custom.helix.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      package = inputs.helix.packages.${system}.default;
      extraPackages = with pkgs; [
        typescript
        gopls
        rust-analyzer
        typescript-language-server
        yamlfmt
        topiary
      ];
      languages = {
        language-server = {
          gopls.config.formatting.gofumpt = true;
          typescript-language-server.config.tsserver = {
            path =
              "${pkgs.typescript}/lib/node_modules/typescript/lib/tsserver.js";
          };
          efm-lsp-prettier = with pkgs; {
            command = "${efm-langserver}/bin/efm-langserver";
            config = {
              documentFormatting = true;
              languages = {
                typescript = [{
                  formatCommand =
                    "${nodePackages.prettier}/bin/prettier --stdin-filepath \${INPUT}";
                  formatStdin = true;
                }];
              };
            };
          };
        };
        language = [
          {
            name = "nu";
            auto-format = true;
            formatter = {
              command = "topiary";
              args = [ "format" "--language" "nu" ];
            };
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              { name = "efm-lsp-prettier"; }
            ];
          }
          {
            name = "yaml";
            auto-format = true;
            formatter = {
              command = "yamlfmt";
              args = [ "-" ];
            };
            language-servers = [{
              name = "efm-lsp-prettier";
              # args = [ "--parser" "yaml" ];
            }];
          }
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
            scope = "source.nix";
          }
        ];
      };
    };
  };
}
