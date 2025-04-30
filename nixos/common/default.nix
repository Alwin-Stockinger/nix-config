{ inputs, outputs, lib, config, pkgs, system, ... }: {
  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  console.keyMap = "de";

  users.users = {
    alwin = {
      isNormalUser = true;
      description = "Alwin Stockinger";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages = [ pkgs.parted pkgs.vim ];

  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 1w";
  };

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  programs.zsh.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  pipewire.enable = lib.mkDefault false;
  desktop.enable = lib.mkDefault false;
  virt.enable = lib.mkDefault false;
  gaming.enable = lib.mkDefault false;

  imports = [
    ./features/sound.nix
    ./features/desktop.nix
    ./features/containers.nix
    ./features/gaming.nix
  ];
}
