{ inputs, ... }:

{

  # nix-darwin configurations
  parts.darwinConfigurations.holden = {
    system = "aarch64-darwin";
    stateVersion = 4; # only change this if you know what you are doing.
    modules = [ ./holden ];
  };
}
