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
      inputs.nixgl.overlay
    ];
  };

  home.packages = with pkgs; [
    trivy
  ];

  home.homeDirectory = "/var/home/alwin";

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

        rec-git = "flux reconcile source git flux-system";

        pus = "pulumi up --suppress-outputs --stack";
        pcg = "pulumi config get --stack";
        pcs = "pulumi config set --stack";

        pr = "gh pr create -a @me -r samox73,SoMuchForSubtlety";
        pr-sam = "gh pr create -a @me -r samox73";
        pr-pasha = "gh pr create -a @me -r pmikh";
        pr-jakob = "gh pr create -a @me -r SoMuchForSubtlety";
      };

      localVariables = {
        WORK = "true";
      };
    };

    k9s = {
      enable = true;
      catppuccin.enable = true;
    };
  };

  imports = [
    ../default.nix
  ];

  desktop.enable = false;
  custom.work = true;
}
