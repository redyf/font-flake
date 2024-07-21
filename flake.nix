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
          cascadia-code = pkgs.stdenv.mkDerivation {
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

          sf-mono = pkgs.stdenv.mkDerivation {
            pname = "SFMono-Nerd-Font-Ligaturized";
            version = "1.0";
            src = pkgs.fetchFromGitHub {
              owner = "shaunsingh";
              repo = "SFMono-Nerd-Font-Ligaturized";
              rev = "dc5a3e6fcc2e16ad476b7be3c3c17c2273b260ea";
              hash = "sha256-AYjKrVLISsJWXN6Cj74wXmbJtREkFDYOCRw1t2nVH2w=";
            };
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \;
            '';
          };

          ubuntu-mono-ligaturized = pkgs.stdenv.mkDerivation {
            pname = "UbuntuMono-Ligaturized";
            version = "1.0";
            src = pkgs.fetchFromGitHub {
              owner = "redyf";
              repo = "ubuntumono-ligaturized";
              rev = "129df21a89511d9c2c22ec49301e67eb6a794412";
              hash = "sha256-wYowJv/5jkr+PsVHy70WLNDrEwDbY6p5KFCkGzn3r3o=";
            };
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
