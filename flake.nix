{
  description = "Terminal based 'The Matrix' like implementation with custom character support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "cmatrix";
            version = "2.0-custom";

            src = ./.;

            nativeBuildInputs = with pkgs; [
              autoconf
              automake
            ];

            buildInputs = with pkgs; [
              ncurses
            ];

            preConfigure = ''
              autoreconf -i
            '';

            configureFlags = [
              "--enable-unicode"
            ];

            meta = with pkgs.lib; {
              description = "Terminal based Matrix like implementation with custom character support (fork with -U option for emojis)";
              longDescription = ''
                CMatrix is based on the screensaver from The Matrix website.
                It shows text flying in and out in a terminal like as seen in "The Matrix" movie.
                
                This fork adds support for custom characters via the -U flag, allowing you to use
                emojis and unicode characters with configurable frequency via the -F flag.
                
                Example: cmatrix -U "🎄,⭐,🎁,🔔" -F 80
              '';
              homepage = "https://github.com/Castrozan/cmatrix";
              license = licenses.gpl3Plus;
              maintainers = [ ];
              platforms = platforms.unix;
            };
          };

          cmatrix = self.packages.${system}.default;
        };

        apps = {
          default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/cmatrix";
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            autoconf
            automake
            ncurses
            gcc
            gnumake
          ];
        };
      }
    );
}

