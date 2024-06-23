{
  description = "A flake for packaging fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        packages = {
          my-font1 = pkgs.stdenv.mkDerivation {
            pname = "my-font1";
            version = "1.0";
            src = pkgs.fetchurl {
              url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IBMPlexMono.zip";
              sha256 = "06j6aj1d8vhvmdkbbc79m16cskkay240bzf2bx8g9jkarcmj6v0d";
            };
            buildInputs = [pkgs.unzip];
            unpackPhase = ''
              unzip -j $src
            '';
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              mv *.ttf $out/share/fonts/truetype/
            '';
          };

          my-font2 = pkgs.stdenv.mkDerivation {
            pname = "my-font2";
            version = "1.0";
            src = pkgs.fetchurl {
              url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip";
              sha256 = "0n1n7w35xp309cw1b10hzq4sxd3jlzzccs5rhr2x2044bi635kjq";
            };
            buildInputs = [pkgs.unzip];
            unpackPhase = ''
              unzip -j $src
            '';
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              mv *.ttf $out/share/fonts/truetype/
            '';
          };
        };

        defaultPackage = self.packages.${system}.my-font1;
      }
    );
}
