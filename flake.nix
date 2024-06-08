{
  description = "A flake for installing fonts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    berkeley = {
      url = "git+ssh://git@github.com/redyf/berkeley.git";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    berkeley,
  }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      overlays = [
        (final: prev: {
          berkeley = prev.stdenvNoCC.mkDerivation {
            pname = "berkeley-mono";
            version = "dev";
            src = berkeley;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };

          # agave = prev.stdenvNoCC.mkDerivation {
          #   pname = "agave-font";
          #   version = "3.2.1";
          #   src = pkgs.fetchzip {
          #     url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Agave.zip";
          #     sha256 = "sha256-9Q+pkG/DteCnoPNzEPo1sNsJYNcT/3dyjhy/tIQBRG8=";
          #     stripRoot = false;
          #   };
          #   dontConfigure = true;
          #   installPhase = ''
          #     mkdir -p $out/share/fonts/opentype
          #     cp -R $src/*.ttf $out/share/fonts/opentype/
          #   '';
          # };
        })
      ];
    };
  in {
    packages = {
      x86_64-linux = {
        fonts = pkgs.stdenv.mkDerivation {
          name = "fonts";
          dontUnpack = true;
          buildInputs = [
            pkgs.berkeley
            pkgs.agave
          ];
          installPhase = ''
            mkdir -p $out/share/fonts/opentype
            cp -R ${pkgs.berkeley}/share/fonts/opentype/*.otf $out/share/fonts/opentype/
            # cp -R ${pkgs.agave}/share/fonts/opentype/*.ttf $out/share/fonts/opentype/
          '';
        };
      };
    };

    nixosConfigurations = {
      redyf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({
            config,
            pkgs,
            ...
          }: {
            environment.systemPackages = [
              pkgs.berkeley
              # pkgs.agave
            ];
          })
        ];
      };
    };
  };
}
