{
  description = "ssh2incus - SSH server for Incus instances";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      forSystems =
        f:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forSystems (pkgs: {
        ssh2incus = pkgs.callPackage ./package.nix { };
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.ssh2incus;
      });

      overlays.default = _final: prev: {
        ssh2incus = self.packages.${prev.stdenv.hostPlatform.system}.ssh2incus;
      };

      nixosModules.default = import ./module.nix self;
    };
}
