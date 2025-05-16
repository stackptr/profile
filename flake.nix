{
  description = "Profile web page";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        makeWrapper = pkgs.makeWrapper;
        nodejs = pkgs.nodejs_22;
        yarn = pkgs.yarn;
        prefetch-yarn-deps = pkgs.prefetch-yarn-deps;
        fixup-yarn-lock = pkgs.fixup-yarn-lock;
        app = pkgs.stdenv.mkDerivation (finalAttrs: {
          name = "profile";
          src = ./.;
          offlineCache = pkgs.fetchYarnDeps {
            yarnLock = "${finalAttrs.src}/yarn.lock";
            hash = "sha256-01UPIijrdT7wE2Dem3HOyP6DJsVmmiBf6uqGk4PvUp0=";
          };
          nativeBuildInputs = [
            makeWrapper
            nodejs
            fixup-yarn-lock
            prefetch-yarn-deps
            yarn
          ];
          configurePhase = ''
            runHook preConfigure

            export HOME=$(mktemp -d)
            yarn config --offline set yarn-offline-mirror $offlineCache
            fixup-yarn-lock yarn.lock
            yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
            patchShebangs node_modules

            runHook postConfigure
          '';

          buildPhase = ''
            runHook preBuild

            yarn --offline build

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/lib
            cp -R . $out/lib
            makeWrapper "${nodejs}/bin/node" "$out/bin/profile" \
              --add-flags "$out/lib/dist/index.js"

            runHook postInstall
          '';
        });
      in {
        packages = {
          default = app;
        };
      }
    );
}
