{ inputs, ... }:

{

  # nix-darwin configurations
  parts.darwinConfigurations.holden = {
    system = "aarch64-darwin";
    stateVersion = 4; # only change this if you know what you are doing.
    modules = [ ./holden
    #  inputs.home.nixosModules.home-manager
    #     {
    #       home-manager.useGlobalPkgs = true;
    #       home-manager.useUserPackages = true;
    #       home-manager.users.alwin = import ../home/common.nix;

    #       # Optionally, use home-manager.extraSpecialArgs to pass
    #       # arguments to home.nix
    #     } 
         ];
  };
}
