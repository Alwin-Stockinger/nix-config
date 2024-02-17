{ config, lib, inputs, ... }:

{
  # home-manager configurations
  parts.homeConfigurations = {
    "alwin@holden" = {
      system = "aarch64-darwin";
      stateVersion = "23.11";

      modules = [ ./alwin/home.nix ];
    };
  };
}
