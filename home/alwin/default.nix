{ config, pkgs, inputs, outputs, lib, ... }:
let
  cfg = config.custom;
  zsh-theme = builtins.toFile "work.zsh-theme"
    "\n        PROMPT=\"%{$fg_bold[cyan]%}%c%{$reset_color%}\"\n        PROMPT+=' $(kube_ps1) '\n        #PROMPT+=' $(git_prompt_info)'\n\n\n        ZSH_THEME_GIT_PROMPT_PREFIX=\"%{$fg_bold[blue]%}git:(%{$fg[red]%}\"\n        ZSH_THEME_GIT_PROMPT_SUFFIX=\"%{$reset_color%} \"\n        ZSH_THEME_GIT_PROMPT_DIRTY=\"%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}\"\n        ZSH_THEME_GIT_PROMPT_CLEAN=\"%{$fg[blue]%})\"\n        KUBE_PS1_PREFIX=\"(\"\n        KUBE_PS1_SUFFIX=\")\"\n        KUBE_PS1_SYMBOL_DEFAULT=\"\"\n        KUBE_PS1_CTX_COLOR=\"red\"\n        KUBE_PS1_NS_COLOR=\"red\"\n        KUBE_PS1_BG_COLOR=\"\"\n        KUBE_PS1_DIVIDER=''\n        KUBE_PS1_SEPARATOR=''\n        KUBE_PS1_NS_ENABLE=false";
  min-packages = with pkgs; [ ];
  standard-packages = with pkgs; [
    neofetch
    tldr
    sops
    yq-go
    dig
    htop
    wget
    postgresql
  ];
in {
  options = {
    custom.work = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    home = { packages = min-packages ++ standard-packages; };
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "Alwin";
            email = "alwin@stockinger.tech";
          };
          rebase.autostash = true;
          pull = { rebase = true; };
          push = { autoSetupRemote = true; };
        };
        ignores = [ "*.DS_Store" ];
        diff-so-fancy.enable = true;
      };

      gh = { enable = true; };
    };

    nixpkgs = {
      config = { allowUnfree = true; };
      #      overlays = [
      #        outputs.overlays.unstable-packages
      #      ];
    };

    home.username = "alwin";
    home.stateVersion = "24.05";

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;

      initContent =
        "\n export TOPIARY_CONFIG_FILE=/Users/alwin-stockinger/Developer/open-source/topiary-nushell/languages.ncl \n export TOPIARY_LANGUAGE_DIR=/Users/alwin-stockinger/Developer/open-source/topiary-nushell/languages   \n  path+=('/run/current-system/sw/bin/')\n  path+=('/Applications/Visual Studio Code.app/Contents/Resources/app/bin')\n  path+=('/etc/profiles/per-user/alwin/bin')\n  path+=('/var/home/alwin/.cargo/bin')\n  path+=('/var/home/alwin/go/bin')\n  path+=('/var/home/alwin/.local/bin')\n\n  eval \"$(zoxide init zsh)\"\n  if [ -n \"\${commands[fzf-share]}\" ]; then\n    source \"$(fzf-share)/key-bindings.zsh\"\n    source \"$(fzf-share)/completion.zsh\"\n  fi\n    #alias ssh=\"kitten ssh\"\n  if [[ $WORK == \"true\" ]]; then\n    echo \"work detected\"\n    export PATH=\"\${KREW_ROOT:-$HOME/.krew}/bin:$PATH\"\n    source <(kubectl completion zsh)\n    complete -C '/usr/bin/aws_completer' aws\n    #source <(pulumi completion zsh)\n    source <(helm completion zsh)\n    source <(kaf completion zsh)\n    eval \"$(/opt/homebrew/bin/brew shellenv)\"\n  fi\n      ";

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "kube-ps1" ];
        theme = if cfg.work then "work" else "aussiegeek";
        custom = zsh-theme;
      };

      shellAliases = {
        switch = "git switch";
        pull = "git pull";
        git-link = "gh browse $(git rev-parse HEAD) -n";

        ts = "tailscale";
      };
    };

    programs = {
      atuin = {
        enable = true;
        settings = {
          # Dont clear screen
          style = "full";
          inline_height = 0;
        };
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      zellij = {
        enable = true;
        #enableZshIntegration = true;
        extraConfig = ''
          default_shell "nu"
        '';
      };
    };
    custom.helix.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.catppuccin.homeModules.catppuccin
    ./features/desktop.nix
    ./features/development
    ./features/gpg
  ];
}
