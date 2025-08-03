{ inputs, outputs, lib, config, pkgs, system, ... }: {
  imports = [ ../common ./hardware ];

  sops = {
    gnupg.home = "/home/alwin/.gnupg";
    gnupg.sshKeyPaths = [ ];
    secrets.valheim_env = { sopsFile = ../../secrets.yaml; };
  };

  networking = {
    hostName = "bobby";
    firewall = { allowedUDPPorts = [ 2456 2457 ]; };
    interfaces.enp6s0.ipv4.addresses = [{
      address = "192.168.1.31";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
  };

  services.openssh.enable = true;

  system.stateVersion = "23.11";

  environment.systemPackages = [ pkgs.pulseaudio ];

  # for blue ray
  boot.kernelModules = [ "sg" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  #valheim server
  #qvirtualisation.oci-containers.containers.valheim = {
  #  image = "lloesche/valheim-server";
  #   ports = ["2456-2457:2456-2457/udp"];
  #
  #   extraOptions = ["--cap-add=sys_nice"];
  #
  #  volumes = [
  #     "/home/alwin/valheim-server/config:/config"
  #     "/home/alwin/valheim-server/data:/data"
  #   ];
  #   environmentFiles = [config.sops.secrets.valheim_env.path];
  #   environment = {
  #     SERVER_NAME = "Valengbach";
  #     WORLD_NAME = "Valengbach";
  #SERVER_PUBLIC = "false";
  #   };
  # };

  systemd.services.podman-valheim = {
    requires = [ "run-secrets.d.mount" ];
    after = [ "run-secrets.d.mount" ];
  };

  custom = {
    virt.enable = true;
    pipewire.enable = true;
    desktop.enable = true;
    gaming.enable = true;
    arr.enable = true;
  };
}
