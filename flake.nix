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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
  in {
    #Raspberry Pi
    nixosConfigurations."alex" = inputs.nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";

      specialArgs = {inherit inputs;};

      modules = [
        #inputs.sops-nix.nixosModules.sops
        {
          environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
        }
        ./hosts/alex
      ];
    };

    #x86 Tower
    nixosConfigurations."bobby" = inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {inherit inputs;};

      modules = [
        inputs.sops-nix.nixosModules.sops
        {
          environment.systemPackages = [inputs.alejandra.defaultPackage.${system}];
        }
        ./hosts/bobby
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.alwin = import ./home/linux.nix;
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
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.alwin = import ./home/darwin.nix;
        }
      ];
    };

    #2019 Macbook Pro
    darwinConfigurations."chrisjen" = inputs.darwin.lib.darwinSystem rec {
      specialArgs = {inherit inputs;};

      system = "x86_64-darwin";

      modules = [
        ./darwin/x86_64.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs;};
          home-manager.users.alwin = import ./home/darwin.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    #darwinPackages = self.darwinConfigurations."Chrisjen".pkgs;
  };
}
