{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "alwin";
  #home.homeDirectory = "/Users/alwin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    neofetch
    tldr
    vim
    htop
    bat
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alwin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.git = {
    enable = true;
    userName = "Alwin";
    userEmail = "alwin@stockinger.tech";
    extraConfig = {
      push = {
        autoSetupRemote = true;
      };
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    initExtra = "
      path+=('/run/current-system/sw/bin/')
      path+=('/Applications/Visual Studio Code.app/Contents/Resources/app/bin')
      path+=('/etc/profiles/per-user/alwin/bin')
    ";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "robbyrussell";
    };
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language = [
        {
          name = "nix";
          indent = {
            tab-width = 2;
            unit = " ";
          };
          auto-format = true;
        }
      ];
    };
    settings = {
      editor = {
        line-number = "relative";
      };
    };
  };

  programs.vscode = {
    enable = true;
    userSettings = {
      "window.zoomLevel" = 1;
      "editor.formatOnSave" = true;
      "editor.formatOnSaveMode" = "file";
    };
    extensions = with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide
      ms-python.black-formatter
      kamadorueda.alejandra
    ];
    #    extensions = with pkgs.vscode-extensions; [
    #
    #    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #      {
    #        name = "nix-ide";
    #        publisher = "jnoortheen";
    #        version = "0.2.2";
    #      }
    #    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
