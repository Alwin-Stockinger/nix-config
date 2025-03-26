{ pkgs
, lib
, inputs
, outputs
, system
, ...
}: {
  imports = [
    ./default.nix
  ];

  users.users.alwin-stockinger.home = lib.mkForce "/Users/alwin-stockinger";

  # because previous install was fucked
  ids.gids.nixbld = 350;

  homebrew = {
    enable = true;
    taps = [
      "pulumi/tap"
    ];
    brews = [
      "pulumi"
    ];
    casks = [
      "slack"
      "microsoft-teams"
      "microsoft-outlook"
      "gitify"
    ];
  };
}
