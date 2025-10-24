{ config, pkgs, inputs, lib, outputs, ... }: {
  nixpkgs = {
    overlays = [
      #      outputs.overlays.unstable-packages
      #inputs.nixgl.overlay
    ];
  };

  home = {
    packages = with pkgs; [
      trivy
      nodejs
      nodePackages.cdk8s-cli
      mongosh
      fluxcd
      kubernetes-helm
      kaf
      kubectx
      krew
      kubectl-cnpg
      (pkgs.python3.withPackages (ppkgs: [ ppkgs.requests ppkgs.pytz ]))
      parallel
      podman
      docker
      _1password-cli
      diceware
      postgresql
      dyff
      hwatch
      rainfrog
      kubeconform
      kubelogin
      nufmt # this is broken af
      gum
      maven
      talosctl
      difftastic
      yamlfmt
      gawk
      topiary
      terraform
      raycast
      claude-code
    ];

    homeDirectory = "/Users/alwin-stockinger";
    username = lib.mkForce "alwin-stockinger";
  };

  programs = {
    git = {
      settings = {
        user = { email = lib.mkForce "alwin.stockinger@volue.com"; };
      };
    };
    zsh = {
      oh-my-zsh.custom = lib.mkForce "$HOME/nix-config/home/alwin/work/zsh";
      oh-my-zsh.theme = lib.mkForce "work";
      shellAliases = {
        ll = "ls -l";

        k = "kubectl";
        kustomize = "kubectl kustomize";
        pods = "kubectl get pods -o wide";

        ctx = "kubectx";
        ex-machina = "kubectx ex-machina";
        dev = "kubectx dev";

        b64 = "base64";

        pus = "pulumi up --suppress-outputs --stack";
        pcg = "pulumi config get --stack";
        pcs = "pulumi config set --stack";

        pr = "gh pr create -a @me --fill -r samox73,SoMuchForSubtlety";
        pr-sam = "gh pr create -a @me --fill -r samox73";
        pr-pasha = "gh pr create -a @me --fill -r pmikh";
        pr-jakob = "gh pr create -a @me --fill -r SoMuchForSubtlety";
        pr-wu = "gh pr create -a @me --fill -r TwoFingerProgrammer";
      };

      localVariables = { WORK = "true"; };
    };

    awscli.enable = true;

    k9s = {
      enable = true;
      views = {
        views = {
          "v1/pods" = {
            sortColumn = "AGE:asc";
            columns = [
              "NAMESPACE"
              "NAME"
              "AGE"
              "STATUS"
              "NODE"
              "'%CPU/R|'"
              "'%MEM/R|'"
            ];
          };
        };
      };
    };
    nushell = {
      enable = true;
      configFile = {
        text = ''
          const NU_LIB_DIRS = $NU_LIB_DIRS ++ [ "~/Developer/volue/flux-powerbot/nushell"]
          source "~/Developer/volue/flux-powerbot/nushell/mod.nu"
        '';
      };
      shellAliases = {
        ll = "ls -l";

        k = "kubectl";
        kustomize = "kubectl kustomize";
        pods = "kubectl get pods -o wide";

        ctx = "kubectx";
        ex-machina = "kubectx ex-machina";
        dev = "kubectx dev";

        b64 = "base64";

        pus = "pulumi up --suppress-outputs --stack";
        pcg = "pulumi config get --stack";
        pcs = "pulumi config set --stack";

        pr = "gh pr create -a @me --fill -r samox73,SoMuchForSubtlety";
        pr-sam = "gh pr create -a @me --fill -r samox73";
        pr-pasha = "gh pr create -a @me --fill -r pmikh";
        pr-jakob = "gh pr create -a @me --fill -r SoMuchForSubtlety";
        pr-wu = "gh pr create -a @me --fill -r TwoFingerProgrammer";

      };
    };
  };

  imports = [ ../default.nix ];

  desktop.enable = false;
  custom.work = true;
  development.enable = true;
}
