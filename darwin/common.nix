{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
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
  #system.configurationRevision = outputs.rev or outputs.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
}
