{
  description = "Darwin system flake";

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


  outputs = inputs@{ self, darwin, nixpkgs, home-manager, ... }:
  let
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    
    nixpkgs.config.allowUnfree = true;
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
        nixpkgs.config.allowUnfree = true;

        nix.settings = {
          # Enable flakes and new 'nix' command
          experimental-features = "nix-command flakes";
          # Deduplicate and optimize nix store
          auto-optimise-store = true;
        };

        system = "x86_64-linux";

        networking.hostName = "bobby";
        networking.networkmanager.enable = true;

        # Bootloader.
        boot.loader.grub.enable = true;
        boot.loader.grub.device = "/dev/sda";
        boot.loader.grub.useOSProber = true;

        time.timeZone = "Europe/Vienna";

        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
          LC_ADDRESS = "de_AT.UTF-8";
          LC_IDENTIFICATION = "de_AT.UTF-8";
          LC_MEASUREMENT = "de_AT.UTF-8";
          LC_MONETARY = "de_AT.UTF-8";
          LC_NAME = "de_AT.UTF-8";
          LC_NUMERIC = "de_AT.UTF-8";
          LC_PAPER = "de_AT.UTF-8";
          LC_TELEPHONE = "de_AT.UTF-8";
          LC_TIME = "de_AT.UTF-8";
        };

        console.keyMap = "de";


        users.users = {
          alwin = {
            isNormalUser = true;
            description = "Alwin Stockinger";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with nixpkgs; [];
          };
        };

        imports = [
          ./hardware
          ];

        modules = [
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
