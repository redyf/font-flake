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
          my-font = pkgs.stdenv.mkDerivation {
            pname = "my-font";
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
        };

        defaultPackage = self.packages.${system}.my-font;
      }
    );
}
