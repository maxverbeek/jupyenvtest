{
  description = "Your jupyenv project";

  nixConfig.extra-substituters = [ "https://tweag-jupyter.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];
  # nixConfig.permittedInsecurePackages = [ "qtwebkit-5.212.0-alpha4" ];

  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.jupyenv.url = "github:tweag/jupyenv";

  outputs = { self, flake-compat, flake-utils, nixpkgs, jupyenv, ... }@inputs:
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let
        inherit (jupyenv.lib.${system}) mkJupyterlabNew;
        jupyterlab = mkJupyterlabNew ({ ... }: {
          nixpkgs = inputs.nixpkgs;
          imports = [ (import ./kernels.nix) ];
        });
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in rec {
        packages = { inherit jupyterlab; };
        packages.default = jupyterlab;
        apps.default.program = "${jupyterlab}/bin/jupyter-lab";
        apps.default.type = "app";
        devShell = pkgs.mkShell { buildInputs = [ pkgs.poetry ]; };
      });
}
