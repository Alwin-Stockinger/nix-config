{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  options.gpg = {
    enable = lib.mkEnableOption "enables gpg and friends";
  };

  config = lib.mkIf config.gpg.enable {
    home.packages = with pkgs; [
      pinentry-curses # for gpg
    ];

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    programs.gpg = {
      enable = true;

      mutableTrust = false;

      publicKeys = [
        {
          source = ./bobby.pub;
          trust = 5;
        }
      ];
    };
  };
}
