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

  users.users.alwin.home = "/Users/alwin";

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
        _HIHideMenuBar = true;
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
    aerospace = {
      enable = true;
      settings = {
        gaps = {
          outer = {
            left = 0;
            bottom = 0;
            top = 0;
            right = 0;
          };
        };
        mode.main.binding = {
          alt-h = "focus left";
          alt-j = "focus down";
          alt-k = "focus up";
          alt-l = "focus right";
          alt-shift-h = "move left";
          alt-shift-j = "move down";
          alt-shift-k = "move up";
          alt-shift-l = "move right";
          alt-1 = "workspace 1";
          alt-2 = "workspace 2";
          alt-3 = "workspace 3";
          alt-4 = "workspace 4";
          #alt-5 = "workspace 5";
          #alt-6 = "workspace 6";
          #alt-7 = "workspace 7";
          #alt-8 = "workspace 8";
          #alt-9 = "workspace 9";

          alt-shift-1 = "move-node-to-workspace 1";
          alt-shift-2 = "move-node-to-workspace 2";
          alt-shift-3 = "move-node-to-workspace 3";
          alt-shift-4 = "move-node-to-workspace 4";
          alt-shift-5 = "move-node-to-workspace 5";
          alt-shift-6 = "move-node-to-workspace 6";
          alt-shift-7 = "move-node-to-workspace 7";
          alt-shift-8 = "move-node-to-workspace 8";
          alt-shift-9 = "move-node-to-workspace 9";
        };
        workspace-to-monitor-force-assignment = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
        };
        on-window-detected = [
          {
            "if" = {
              app-id = "com.tinyspeck.slackmacgap";
            };
            run = [ "move-node-to-workspace 3" ];
          }
        ];
      };
    };

    sketchybar = {
      enable = true;
      extraPackages = [
        pkgs.aerospace
      ];
    };

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
