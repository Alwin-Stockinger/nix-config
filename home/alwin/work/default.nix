{
  config,
  pkgs,
  inputs,
  lib,
  outputs,
  ...
}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };

  home.packages = with pkgs; [
    pkgs.grpcurl
    pkgs.iperf3
  ];

  programs.home-manager.enable = true;

  home.username = "alwin";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.homeDirectory = "/var/home/alwin";

  programs.git = {
    userEmail = lib.mkForce "alwin.stockinger@powerbot-trading.com";
  };

  programs.zsh = {
    oh-my-zsh.custom = lib.mkForce "$HOME/nix-config/home/alwin/work/zsh";
    oh-my-zsh.theme = lib.mkForce "work";
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

    localVariables = {
      WORK = "true";
    };
  };

  imports = [
    ../common/desktop.nix
    ../features/vscode.nix
  ];
}
