{
  pkgs,
  lib,
  inputs,
  outputs,
  system,
  ...
}: {
  nixpkgs.hostPlatform = system;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  users.users.alwin.home = "/Users/alwin";

  system = {
    # activationScripts.postUserActivation.text = ''
    #   # activateSettings -u will reload the settings from the database and apply them to the current session,
    #   # so we do not need to logout and login again to make the changes take effect.
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    defaults.dock.wvous-tr-corner = 2;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 1w";
  };

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  environment.systemPackages = [
    pkgs.vim
  ];

  programs.zsh.enable = true;

  services.tailscale.enable = true;
}
