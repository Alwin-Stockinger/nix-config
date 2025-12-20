{ pkgs, lib, inputs, outputs, system, ... }: {
  nixpkgs.hostPlatform = system;
  #  nixpkgs.hostPlatform = "aarch64-darwin";

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;
  nix.linux-builder.enable = true;

  users.users.alwin.home = "/Users/alwin";

  system = {
    # activationScripts.postUserActivation.text = ''
    #   # activateSettings -u will reload the settings from the database and apply them to the current session,
    #   # so we do not need to logout and login again to make the changes take effect.
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    #defaults.CustomUserPreferences."com.apple.mouse.scaling" = -1;

    defaults = {
      controlcenter = { BatteryShowPercentage = true; };

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

    primaryUser = "alwin";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      build-dir = "/var/tmp";
      # Binary caches
      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
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
          cmd-h = "focus left";
          cmd-j = "focus down";
          cmd-k = "focus up";
          cmd-l = "focus right";
          cmd-shift-h = "move left";
          cmd-shift-j = "move down";
          cmd-shift-k = "move up";
          cmd-shift-l = "move right";
          cmd-1 = "workspace 1";
          cmd-2 = "workspace 2";
          cmd-3 = "workspace 3";
          cmd-4 = "workspace 4";
          # cmd-5 = "workspace 5";
          #cmd-6 = "workspace 6";
          #cmd-7 = "workspace 7";
          #cmd-8 = "workspace 8";
          #cmd-9 = "workspace 9";

          cmd-shift-1 = [ "move-node-to-workspace 1" "workspace 1" ];
          cmd-shift-2 = [ "move-node-to-workspace 2" "workspace 2" ];
          cmd-shift-3 = [ "move-node-to-workspace 3" "workspace 3" ];
          cmd-shift-4 = [ "move-node-to-workspace 4" "workspace 4" ];
          cmd-shift-5 = [ "move-node-to-workspace 5" "workspace 5" ];
          cmd-shift-6 = [ "move-node-to-workspace 6" "workspace 6" ];
          #cmd-shift-7 = [ "move-node-to-workspace 7" "workspace 7" ];
          cmd-shift-8 = [ "move-node-to-workspace 8" "workspace 8" ];
          cmd-shift-9 = [ "move-node-to-workspace 9" "workspace 9" ];

          cmd-comma = "layout accordion horizontal vertical";
          cmd-period = "layout tiles horizontal vertical";

          cmd-minus = "resize smart -50";
          cmd-equal = "resize smart +50";

          # alt-shift-s = "exec-and-forget screencapture -i -c";
        };
        workspace-to-monitor-force-assignment = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
        };
        on-window-detected = [
          {
            "if" = { app-id = "com.tinyspeck.slackmacgap"; };
            run = [ "move-node-to-workspace 3" ];
          }
          {
            "if" = { app-id = "com.microsoft.teams"; };
            run = [ "move-node-to-workspace 3" ];
          }
          {
            "if" = { app-id = "com.microsoft.outlook"; };
            run = [ "move-node-to-workspace 3" ];
          }
        ];
      };
    };

    sketchybar = {
      enable = false;
      extraPackages = [ pkgs.aerospace ];
      config = ''
        ############## BAR ##############
            sketchybar -m --bar \
              height=32 \
              position=top \
              padding_left=5 \
              padding_right=5 \
              color=0xff2e3440 \
              shadow=off \
              sticky=on \
              topmost=off

          ############## GLOBAL DEFAULTS ##############
            sketchybar -m --default \
              updates=when_shown \
              drawing=on \
              cache_scripts=on \
              icon.font="JetBrainsMono Nerd Font Mono:Bold:18.0" \
              icon.color=0xffffffff \
              label.font="JetBrainsMono Nerd Font Mono:Bold:12.0" \
              label.color=0xffeceff4 \
              label.highlight_color=0xff8CABC8

          ############## SPACE DEFAULTS ##############
            sketchybar -m --default \
              label.padding_left=5 \
              label.padding_right=2 \
              icon.padding_left=8 \
              label.padding_right=8

          ############## PRIMARY DISPLAY SPACES ##############
            # APPLE ICON
            sketchybar -m --add item apple left \
              --set apple icon= \
              --set apple label.padding_right=0 \

            # SPACE 1: WEB ICON
            sketchybar -m --add space web left \
              --set web icon= \
              --set web icon.highlight_color=0xff8CABC8 \
              --set web associated_space=1 \
              --set web icon.padding_left=5 \
              --set web icon.padding_right=5 \
              --set web label.padding_right=0 \
              --set web label.padding_left=0 \
              --set web label.color=0xffeceff4 \
              --set web background.color=0xff57627A  \
              --set web background.height=21 \
              --set web background.padding_left=12 \
              --set web click_script="open -a Firefox.app" \

            # SPACE 2: CODE ICON
            sketchybar -m --add space code left \
              --set code icon= \
              --set code associated_space=2 \
              --set code icon.padding_left=5 \
              --set code icon.padding_right=5 \
              --set code label.padding_right=0 \
              --set code label.padding_left=0 \
              --set code label.color=0xffeceff4 \
              --set code background.color=0xff57627A  \
              --set code background.height=21 \
              --set code background.padding_left=7 \
              --set code click_script="$HOME/.nix-profile/bin/wezterm" \

            # SPACE 3: MUSIC ICON
            #sketchybar -m --add space music left \
            #  --set music icon= \
            #  --set music icon.highlight_color=0xff8CABC8 \
            #  --set music associated_display=1 \
            #  --set music associated_space=5 \
            #  --set music icon.padding_left=5 \
            #  --set music icon.padding_right=5 \
            #  --set music label.padding_right=0 \
            #  --set music label.padding_left=0 \
            #  --set music label.color=0xffeceff4 \
            #  --set music background.color=0xff57627A  \
            #  --set music background.height=21 \
            #  --set music background.padding_left=7 \
            #  --set music click_script="open -a Spotify.app" \

          ############## ITEM DEFAULTS ###############
            sketchybar -m --default \
              label.padding_left=2 \
              icon.padding_right=2 \
              icon.padding_left=6 \
              label.padding_right=6


          ###################### CENTER ITEMS ###################


          ############## FINALIZING THE SETUP ##############
          sketchybar -m --update

          echo "sketchybar configuration loaded.."
      '';
    };
  };

  homebrew = {
    enable = true;
    casks =
      [ "firefox" "signal" "visual-studio-code" "kitty" "microsoft-teams" ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
