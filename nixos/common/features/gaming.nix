{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    gaming.enable = lib.mkEnableOption "enables gaming";
  };

  config = lib.mkIf config.gaming.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatabilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
