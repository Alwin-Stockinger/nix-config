{ config
, pkgs
, inputs
, outputs
, lib
, ...
}:
let
  cfg = config.custom;
  zsh-theme = builtins.toFile "work.zsh-theme" "
        PROMPT=\"%{$fg_bold[cyan]%}%c%{$reset_color%}\"
        PROMPT+=' $(kube_ps1) '
        #PROMPT+=' $(git_prompt_info)'


        ZSH_THEME_GIT_PROMPT_PREFIX=\"%{$fg_bold[blue]%}git:(%{$fg[red]%}\"
        ZSH_THEME_GIT_PROMPT_SUFFIX=\"%{$reset_color%} \"
        ZSH_THEME_GIT_PROMPT_DIRTY=\"%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}\"
        ZSH_THEME_GIT_PROMPT_CLEAN=\"%{$fg[blue]%})\"
        KUBE_PS1_PREFIX=\"(\"
        KUBE_PS1_SUFFIX=\")\"
        KUBE_PS1_SYMBOL_DEFAULT=\"\"
        KUBE_PS1_CTX_COLOR=\"red\"
        KUBE_PS1_NS_COLOR=\"red\"
        KUBE_PS1_BG_COLOR=\"\"
        KUBE_PS1_DIVIDER=''
        KUBE_PS1_SEPARATOR=''
        KUBE_PS1_NS_ENABLE=false";
  min-packages = with pkgs; [
  ];
  standard-packages = with pkgs; [
    neofetch
    tldr
    bat
    sops
    yq-go
    dig
    htop
    zoxide
    wget
    difftastic
    diff-so-fancy
  ];
in
{
  options = {
    custom.work = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    home = {
      packages =
        min-packages
        ++ standard-packages;
    };
    programs = {
      git = {
        enable = true;
        userName = "Alwin";
        userEmail = "alwin@stockinger.tech";
        ignores = [ "*.DS_Store" ];
        extraConfig = {
          rebase.autostash = true;
          pull = {
            rebase = true;
          };
          push = {
            autoSetupRemote = true;
          };
        };
        diff-so-fancy.enable = true;
      };

      gh = {
        enable = true;
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      #      overlays = [
      #        outputs.overlays.unstable-packages
      #      ];
    };

    home.username = "alwin-stockinger";
    home.stateVersion = "24.05";

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;

      initExtra = "
  path+=('/run/current-system/sw/bin/')
  path+=('/Applications/Visual Studio Code.app/Contents/Resources/app/bin')
  path+=('/etc/profiles/per-user/alwin/bin')
  path+=('/var/home/alwin/.cargo/bin')
  path+=('/var/home/alwin/go/bin')
  path+=('/var/home/alwin/.local/bin')

  eval \"$(zoxide init zsh)\"
  if [ -n \"\${commands[fzf-share]}\" ]; then
    source \"$(fzf-share)/key-bindings.zsh\"
    source \"$(fzf-share)/completion.zsh\"
  fi
    alias ssh=\"kitten ssh\"
  if [[ $WORK == \"true\" ]]; then
    export PATH=\"\${KREW_ROOT:-$HOME/.krew}/bin:$PATH\"
    echo \"work detected\"
    . <(flux completion zsh)
    source <(kubectl completion zsh)
    complete -C '/usr/bin/aws_completer' aws
    #source <(pulumi completion zsh)
    source <(helm completion zsh)
    source <(kaf completion zsh)
  fi
  eval \"$(/opt/homebrew/bin/brew shellenv)\"
      ";

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "kube-ps1"
        ];
        theme =
          if cfg.work
          then "work"
          else "aussiegeek";
        custom = zsh-theme;
      };

      shellAliases = {
        cat = "bat";
        cd = "z";
        ls = "eza";
        diff = "difftastic";

        switch = "git switch";
        pull = "git pull";
        git-link = "gh browse $(git rev-parse HEAD) -n";

        ts = "tailscale";
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin
    ./features/desktop.nix
    ./features/development
    ./features/gpg
  ];
}
