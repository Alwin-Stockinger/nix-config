{
  description = "Alwin Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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

    hyprlock.url = "github:hyprwm/hyprlock";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux"];
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    overlays = import ./overlays {inherit inputs;};

    #Raspberry Pi
    nixosConfigurations."alex" = inputs.nixpkgs.lib.nixosSystem rec {
      system = "aarch64-linux";

      specialArgs = {inherit inputs;};

      modules = [
        ./hosts/alex
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
          home-manager.users.alwin = import ./home/alwin/alex.nix;
        }
      ];
    };

    #x86 Tower
    nixosConfigurations."bobby" = inputs.nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";

      specialArgs = {inherit inputs system;};

      modules = [
        inputs.sops-nix.nixosModules.sops
        ./nixos/bobby
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
          home-manager.users.alwin = import ./home/alwin/bobby.nix;
        }
      ];
    };

    #M2 Macbook Pro
    darwinConfigurations."holden" = inputs.darwin.lib.darwinSystem rec {
      specialArgs = {inherit inputs system;};

      system = "aarch64-darwin";
      nixpkgs.hostPlatform = "aarch64-darwin";

      modules = [
        ./hosts/holden
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
          home-manager.users.alwin = import ./home/alwin/holden.nix;
        }
      ];
    };

    #2019 Macbook Pro
    darwinConfigurations."chrisjen" = inputs.darwin.lib.darwinSystem rec {
      specialArgs = {inherit inputs system;};

      system = "x86_64-darwin";

      modules = [
        ./darwin
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {inherit inputs outputs;};
          home-manager.users.alwin = import ./home/alwin/chrisjen.nix;
        }
      ];
    };

    #Work Laptop
    homeConfigurations."work" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      extraSpecialArgs = {inherit inputs outputs;};

      modules = [./home/alwin/work];
    };
  };
}
