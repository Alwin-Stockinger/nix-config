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
      inputs.nixgl.overlay
    ];
  };

  home.packages = with pkgs; [
    nixgl.nixGLIntel
  ];

  home.homeDirectory = "/var/home/alwin";

  programs.git = {
    userEmail = lib.mkForce "alwin.stockinger@powerbot-trading.com";
  };

  #systemd.user.sessionVariables.NIXOS_OZONE_WL = "1";

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
      pr-jakob = "gh pr create -a @me -r SoMuchForSubtlety";

      git-link = "gh browse $(git rev-parse HEAD) -n";
      cat = "bat";
      pods = "kubectl get pods -o wide";
      switch = "git switch";
      ts = "tailscale";
      code-nix = "code ~/nix-config";
      code-flux = "code ~/powerbot/flux-powerbot";
      tardis = "code ~/powerbot/tardis";
    };

    localVariables = {
      WORK = "true";
    };
  };

  programs.k9s.enable = true;

  imports = [
    ../default.nix
  ];

  desktop.enable = true;
  desktop.waybarMonitor = "eDP-1";
  desktop.monitors = ["eDP-1, 1920x1200, 0x0, 1"];
  custom.work = true;
}
