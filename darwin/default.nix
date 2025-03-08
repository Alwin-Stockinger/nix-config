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
      controlcenter = {
        BatteryShowPercentage = true;
      };

      dock = {
        wvous-tr-corner = 2;
        autohide = true;
        tilesize = 200;
        static-only = true;
      };

      screencapture.target = "clipboard";

      finder = {
        ShowStatusBar = true;
        QuitMenuItem = true;
        FXRemoveOldTrashItems = false;
        FXPreferredViewStyle = "Nlsv";
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };

      NSGlobalDomain = {
        KeyRepeat = 1;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      nonUS.remapTilde = true;
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

  services = {
    tailscale.enable = true;
    aerospace.enable = true;
    #  spacebar.enable = true;
    #   spacebar.package = pkgs.spacebar;
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
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
