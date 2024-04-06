{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    pipewire.enable = lib.mkEnableOption "enables sound with pipewire";
  };

  config = lib.mkIf config.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
