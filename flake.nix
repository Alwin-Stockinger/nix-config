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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: 
  
   {
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    #x86 Tower
    nixosConfigurations."bobby" = inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {inherit inputs;};

      modules = [
        {
          environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
        }
        ./nixos
        inputs.home-manager.nixosModules.home-manager
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
    darwinConfigurations."holden" = inputs.darwin.lib.darwinSystem rec {
      specialArgs = {inherit inputs;};

      system = "aarch64-darwin";

      modules = [
        {
          environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
        }
        ./darwin/aarch64.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nixpkgs.overlays = [
            inputs.nix-vscode-extensions.overlays.default
          ];
          home-manager.users.alwin = import ./home/darwin.nix;
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    #2019 Macbook Pro
    darwinConfigurations."chrisjen" = inputs.darwin.lib.darwinSystem rec {
      specialArgs = {inherit inputs;};

      system = "x86_64-darwin";

      modules = [
        {
          environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
        }
        ./darwin/x86_64.nix
        inputs.home-manager.darwinModules.home-manager
        {
     #     home-manager.useGlobalPkgs = true;
    #      home-manager.useUserPackages = true;
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
