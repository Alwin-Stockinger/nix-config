{
  description = "Alwin Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = { url = "github:nix-community/nixvim/main"; };

    hyprland = { url = "github:hyprwm/Hyprland"; };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl.url = "github:nix-community/nixGL";

    hyprlock.url = "github:hyprwm/hyprlock";

    mac-app-util.url = "github:hraban/mac-app-util";

    helix.url = "github:helix-editor/helix";

    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs =
    { self, nixpkgs, home-manager, nixgl, mac-app-util, nixarr, ... }@inputs:
    let inherit (self) outputs;
    in {
      #     overlays = import ./overlays { inherit inputs; };

      #Raspberry Pi
      nixosConfigurations."alex" = inputs.nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";

        specialArgs = { inherit inputs system; };

        modules = [
          nixarr.nixosModules.default
          ./nixos/alex
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs outputs system; };
              users.alwin = import ./home/alwin/alex.nix;
            };
          }
        ];
      };

      #x86 Tower
      nixosConfigurations."bobby" = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = { inherit inputs system; };

        modules = [
          nixarr.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          ./nixos/bobby
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs outputs system; };
              users.alwin = import ./home/alwin/bobby.nix;
            };
          }
        ];
      };

      #M2 Macbook Pro
      darwinConfigurations."holden" = inputs.darwin.lib.darwinSystem rec {
        specialArgs = { inherit nixpkgs inputs system; };

        system = "aarch64-darwin";

        modules = [
          ./darwin
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              backupFileExtension = "backup";
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs outputs system; };
              users.alwin = import ./home/alwin/holden.nix;
            };
          }
        ];
      };

      #M4 Macbook Work
      darwinConfigurations."Alwins-MacBook-Pro" =
        inputs.darwin.lib.darwinSystem rec {
          specialArgs = { inherit nixpkgs inputs system; };

          system = "aarch64-darwin";

          modules = [
            mac-app-util.darwinModules.default
            ./darwin/work.nix
            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs outputs system; };
                users.alwin-stockinger = import ./home/alwin/work/default.nix;
                sharedModules = [ mac-app-util.homeManagerModules.default ];
              };
            }
          ];
        };
    };
}
