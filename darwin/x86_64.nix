{ pkgs, lib, inputs, outputs, ... }: {
    imports = [
        ./common.nix
    ];
    nixpkgs.hostPlatform = "x86_64-darwin";
}