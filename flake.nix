{
  description = "A flake for packaging fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    # git+ssh://git@git.example.com/User/repo.git if you're using private repos
    BerkeleyMono = {
      url = "git+ssh://git@github.com/redyf/berkeley-mono.git";
      flake = false;
    };
    cartograph = {
      url = "git+ssh://git@github.com/redyf/cartograph.git";
      flake = false;
    };
    monolisa = {
      url = "git+ssh://git@github.com/redyf/monolisa.git";
      flake = false;
    };
    tx02 = {
      url = "git+ssh://git@github.com/redyf/tx-02-trial.git";
      flake = false;
    };
    maple = {
      url = "git+ssh://git@github.com/redyf/maple-font-brackets.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      BerkeleyMono,
      cartograph,
      monolisa,
      tx02,
      maple,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          lilex = pkgs.stdenv.mkDerivation rec {
            pname = "lilex";
            version = "2.600";
            src = pkgs.fetchurl {
              url = "https://github.com/mishamyrt/Lilex/releases/download/${version}/Lilex.zip";
              sha256 = "sha256-G8zm35aSiXrnGgYePSwLMBzwSnd9mfCinHZSG1qBH0w=";
            };
            buildInputs = [ pkgs.unzip ];
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

          monolisa = pkgs.stdenv.mkDerivation {
            pname = "Monolisa";
            version = "2.012";
            src = monolisa;
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              mv *.ttf $out/share/fonts/truetype/
            '';
          };

          cartograph = pkgs.stdenv.mkDerivation {
            pname = "CartographCF";
            version = "1.0";
            src = cartograph;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \;
            '';
          };

          berkeley-mono = pkgs.stdenv.mkDerivation {
            pname = "BerkeleyMono";
            version = "2.002";
            src = BerkeleyMono;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              find $src -type f -name '*.otf' -exec cp {} $out/share/fonts/opentype/ \;
            '';
          };

          tx02 = pkgs.stdenv.mkDerivation {
            pname = "TX-02";
            version = "2.002";
            src = tx02;
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              mv *.ttf $out/share/fonts/truetype/
            '';
          };

          maple = pkgs.stdenv.mkDerivation {
            pname = "Maple-Mono-Debug-Regular";
            version = "7.700";
            src = maple;
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              mv *.ttf $out/share/fonts/truetype/
            '';
          };
        };

        defaultPackage = self.packages.${system}.sf-mono;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.fontconfig
            self.packages.${system}.monolisa
          ];
          shellHook = ''
            # Create fontconfig configuration
            export FONTCONFIG_FILE=${
              pkgs.makeFontsConf {
                fontDirectories = [ self.packages.${system}.monolisa ];
              }
            }
          '';
        };
      }
    );
}
