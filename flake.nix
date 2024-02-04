{
  description = "Alwin Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    darwin,
    nixpkgs,
    home-manager,
    alejandra,
    ...
  }: {
    #x86 Tower
    nixosConfigurations."bobby" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {inherit inputs self;};

      modules = [
        {
          environment.systemPackages = [alejandra.defaultPackage.${system}];
        }
        ./nixos
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alwin = import ./home/nixos.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    #M2 Macbook Pro
    darwinConfigurations."holden" = darwin.lib.darwinSystem {
      specialArgs = {inherit inputs self;};

      modules = [
        ./darwin/aarch64.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alwin = import ./home/darwin.nix;
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    #2019 Macbook Pro
    darwinConfigurations."chrisjen" = darwin.lib.darwinSystem {
      specialArgs = {inherit inputs self;};

      modules = [
        ./darwin/x86_64.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alwin = import ./home/darwin.nix;
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    #darwinPackages = self.darwinConfigurations."Chrisjen".pkgs;
  };
}
