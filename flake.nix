{
  description = "A flake for packaging fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    # git+ssh://git@git.example.com/User/repo.git if you're using private repos
    berkeley = {
      url = "git+ssh://git@github.com/redyf/berkeley.git";
      flake = false;
    };

    monolisa = {
      url = "git+ssh://git@github.com/redyf/monolisa.git";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    berkeley,
    monolisa,
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

          berkeley = pkgs.stdenv.mkDerivation {
            pname = "Berkeley Mono Nerd Font";
            version = "1.0";
            src = berkeley;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \;
            '';
          };

          monolisa = pkgs.stdenv.mkDerivation {
            pname = "Monolisa";
            version = "1.0";
            src = monolisa;
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              mv *.ttf $out/share/fonts/truetype/
            '';
          };
        };

        defaultPackage = self.packages.${system}.sf-mono;
      }
    );
}
