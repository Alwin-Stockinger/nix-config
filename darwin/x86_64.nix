{ pkgs, lib, inputs, outputs, ... }: {
    common = import ./common.nix {inherit pkgs lib inputs outputs;};
}