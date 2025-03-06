{ pkgs
, lib
, inputs
, outputs
, system
, ...
}: {
  nixpkgs.hostPlatform = system;
  #  nixpkgs.hostPlatform = "aarch64-darwin";

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;

  users.users.alwin-stockinger.home = "/Users/alwin";

  system = {
    # activationScripts.postUserActivation.text = ''
    #   # activateSettings -u will reload the settings from the database and apply them to the current session,
    #   # so we do not need to logout and login again to make the changes take effect.
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    #defaults.CustomUserPreferences."com.apple.mouse.scaling" = -1;

    defaults = {
      dock.wvous-tr-corner = 2;
      dock.autohide = true;

      screencapture.target = "clipboard";
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 1w";
    };
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
    };

    optimise.automatic = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;

  services.tailscale.enable = true;

  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "amethyst"
      "signal"
      "visual-studio-code"
      "ghostty"
      "kitty"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
