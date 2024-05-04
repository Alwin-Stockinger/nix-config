{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}: let
  cfg = config.custom;
  zsh-theme =
    builtins
    .toFile "work.zsh-theme" "
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
in {
  options = {
    custom.work = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
      overlays = [
        outputs.overlays.unstable-packages
      ];
    };

    home.username = "alwin";
    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      htop
    ];

    home.sessionVariables = {
      EDITOR = "hx";
    };

    programs.git = {
      enable = true;
      userName = "Alwin";
      userEmail = "alwin@stockinger.tech";
      extraConfig = {
        rebase.autostash = true;
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
  terminal=$(basename \"/\"$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat | cut -d \\  -f 4) | tail -1 | sed 's/ .*$//'))
  if [[ $terminal == \"kitty\" ]]; then
    echo \"kitten detected\"
    alias ssh=\"kitten ssh\"
  fi
  if [[ $WORK == \"true\" ]]; then
    echo \"work detected\"
  fi
      ";

      shellAliases = {
        ll = "ls -l";
        k = "kubectl";
        kustomize = "kubectl kustomize";
        ctx = "kubectx";
        ex-machina = "kubectx ex-machina";
        dev = "kubectx dev";
        b64 = "base64";
        rec-git = "flux reconcile source git flux-system";
        pus = "pulumi up --suppress-outputs --stack";
        pcg = "pulumi config get --stack";
        pcs = "pulumi config set --stack";

        pr = "gh pr create -a @me -r samox73,SoMuchForSubtlety";
        pr-sam = "gh pr create -a @me -r samox73";
        pr-pasha = "gh pr create -a @me -r pmikh";

        git-link = "gh browse $(git rev-parse HEAD) -n";
        cat = "bat";
        pods = "kubectl get pods -o wide";
        switch = "git switch";
        ts = "tailscale";
        code-nix = "code ~/nix-config";
        code-flux = "code ~/powerbot/flux-powerbot";
      };

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
  };

  imports = [
    ./features/desktop.nix
    ./features/development.nix
    ./features/gpg
  ];
}
