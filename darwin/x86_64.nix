{ pkgs, outputs, ... }: {
    imports = [
        ./common.nix { inherit outputs; }
    ];
}