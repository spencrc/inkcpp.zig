{
  description = "Setup latest stable Zig";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, zig-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ 
          (final: prev: {
            zigpkgs = zig-overlay.packages.${prev.system};
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      { 
        devShells.default = with pkgs; mkShell {
          buildInputs = [
            bashInteractive # for vscode

            zigpkgs."0.16.0"

            libx11
            libxrandr
            libxcursor
            libxext
            libxi

            libGL
          ];
        };
      }
    );
}
