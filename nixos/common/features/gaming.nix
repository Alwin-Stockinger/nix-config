{ inputs, lib, config, pkgs, ... }: {
  options = { custom.gaming.enable = lib.mkEnableOption "enables gaming"; };

  config = lib.mkIf config.custom.gaming.enable {
    programs.steam = {
      enable = true;
      #      gamescopeSession.enable = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    environment.systemPackages = with pkgs;
      [
        mangohud
        #protonup
      ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${HOME}/.steam/root/compatabilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
