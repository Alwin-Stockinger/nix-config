{ pkgs, lib, inputs, outputs, ... }: {
    import ./common.nix {inherit pkgs lib inputs outputs;}
}