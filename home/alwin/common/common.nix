{
  config,
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
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
    inputs.alejandra.defaultPackage.${system}
    pkgs.fzf
    pkgs.zoxide
    pkgs.neofetch
    pkgs.tldr
    pkgs.htop
    pkgs.bat
    pkgs.sops
    pkgs.dig
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
      pull = {
        rebase = true;
      };
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
    autocd = true;

    initExtra = "
path+=('/run/current-system/sw/bin/')
path+=('/Applications/Visual Studio Code.app/Contents/Resources/app/bin')
path+=('/etc/profiles/per-user/alwin/bin')
eval \"$(zoxide init zsh)\"
if [ -n \"\${commands[fzf-share]}\" ]; then
  source \"$(fzf-share)/key-bindings.zsh\"
  source \"$(fzf-share)/completion.zsh\"
fi
    ";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      theme = "aussiegeek"; # TODO make custom theme https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.oh-my-zsh.custom
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
          formatter = {
            command = "alejandra";
          };
        }
      ];
    };
    settings = {
      editor = {
        line-number = "relative";
      };
    };
  };

  programs.tmux = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
