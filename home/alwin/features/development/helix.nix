{ config, pkgs, inputs, outputs, lib, system, ... }: {
  config = lib.mkIf config.development.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      package = inputs.helix.packages.${system}.default;
      extraPackages = with pkgs; [
        typescript
        gopls
        rust-analyzer
        typescript-language-server
      ];
      languages = {
        language-server = {
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
            language-servers = [{ name = "efm-lsp-prettier"; }];
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
