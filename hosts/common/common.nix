{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  system,
  ...
}: {
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

  environment.systemPackages = [
    inputs.alejandra.defaultPackage.${system}
    pkgs.vim
  ];

  programs.zsh.enable = true;
}
