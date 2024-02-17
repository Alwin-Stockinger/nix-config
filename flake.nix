{
  description = "Alwin Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    parts.url = "github:hercules-ci/flake-parts";


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
  };
  outputs = inputs: inputs.parts.lib.mkFlake { inherit inputs; }
  {

    systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux"];
    imports = [ ./modules/parts ./hosts ./users ];

    #x86 Tower
    # nixosConfigurations."bobby" = nixpkgs.lib.nixosSystem rec {
    #   system = "x86_64-linux";

    #   specialArgs = {inherit inputs self;};

    #   modules = [
        # {
        #   environment.systemPackages = [alejandra.defaultPackage.${system}];
        # }
    #     ./nixos
    #     home-manager.nixosModules.home-manager
    #     {
    #       home-manager.useGlobalPkgs = true;
    #       home-manager.useUserPackages = true;
    #       home-manager.users.alwin = import ./home/nixos.nix;

    #       # Optionally, use home-manager.extraSpecialArgs to pass
    #       # arguments to home.nix
    #     }
    #   ];
      
    # };


    # #M2 Macbook Pro
    # darwinConfigurations."holden" = darwin.lib.darwinSystem rec {
    #   specialArgs = {inherit inputs self;};

    #  system = "aarch64-darwin";

    #   modules = [
        # {
        #   environment.systemPackages = [alejandra.defaultPackage.${system}];
        # }
    #     ./darwin/aarch64.nix
    #     home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.users.alwin = import ./home/darwin.nix;
  #         # Optionally, use home-manager.extraSpecialArgs to pass
  #         # arguments to home.nix
  #       }
   #    ];
    # };

    # #2019 Macbook Pro
    # darwinConfigurations."chrisjen" = darwin.lib.darwinSystem rec {
    #   specialArgs = {inherit inputs self;};

    #  system = "x86_64-darwin";

    #   modules = [
        # {
        #   environment.systemPackages = [alejandra.defaultPackage.${system}];
        # }
    #     ./darwin/x86_64.nix
    #     home-manager.darwinModules.home-manager
  #       {
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.users.alwin = import ./home/darwin.nix;
  #         # Optionally, use home-manager.extraSpecialArgs to pass
  #         # arguments to home.nix
  #       }
   #    ];
    # };

    # Expose the package set, including overlays, for convenience.
    #darwinPackages = self.darwinConfigurations."Chrisjen".pkgs;
  };
}
