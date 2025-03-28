{ config
, pkgs
, inputs
, lib
, outputs
, ...
}: {
  nixpkgs = {
    overlays = [
      #      outputs.overlays.unstable-packages
      #inputs.nixgl.overlay
    ];
  };

  home = {
    packages = with pkgs; [
      trivy
      #nixgl.nixGLIntel
      nodejs
      nodePackages.cdk8s-cli
      mongosh
      fluxcd
      kubernetes-helm
      kaf
      kubectx
      krew
      kubectl-cnpg
      (pkgs.python3.withPackages (ppkgs: [
        ppkgs.requests
        ppkgs.pytz
      ]))
      parallel
      podman
      docker
      bitwarden-cli
      diceware
      postgresql
      dyff
      hwatch
      rainfrog
      kubeconform
    ];

    homeDirectory = "/Users/alwin-stockinger";
    username = lib.mkForce "alwin-stockinger";
  };

  programs = {
    git = {
      userEmail = lib.mkForce "alwin.stockinger@powerbot-trading.com";
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

      localVariables = {
        WORK = "true";
      };
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
  };

  imports = [
    ../default.nix
  ];

  desktop.enable = false;
  custom.work = true;
  development.enable = true;
}
