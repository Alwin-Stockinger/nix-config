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

    #hyprland.url = "github:hyprwm/Hyprland";
  };


  outputs = { self, darwin, nixpkgs, home-manager, ... }:
  let

    darwinConfiguration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.htop
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      #programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;


      users.users.alwin.home = "/Users/alwin";

      system = {
        # activationScripts.postUserActivation.text = ''
        #   # activateSettings -u will reload the settings from the database and apply them to the current session,
        #   # so we do not need to logout and login again to make the changes take effect.
        #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        # '';

        defaults.dock.wvous-tr-corner = 2;
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      
    };
  in
  {

    #x86 Tower
    nixosConfigurations."bobby" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      system = system = "x86_64-linux";


      modules = [
        ./nixos
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alwin = import ./home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
      
    };


    #M2 Macbook Pro
    darwinConfigurations."holden" = darwin.lib.darwinSystem {
            
      modules = [ 
        darwinConfiguration {
          nixpkgs.hostPlatform = "aarch64-darwin";
        }
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alwin = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
       ];
    };


    #2019 Macbook Pro
    darwinConfigurations."chrisjen" = darwin.lib.darwinSystem {
      
      modules = [ 
        darwinConfiguration {
          nixpkgs.hostPlatform = "x86_64-darwin";
        }
        home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alwin = import ./home.nix;



            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
       ];
    };

    # Expose the package set, including overlays, for convenience.
    #darwinPackages = self.darwinConfigurations."Chrisjen".pkgs;
  };
}
