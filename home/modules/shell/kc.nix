{ pkgs, ... }:

let
  kc = pkgs.rustPlatform.buildRustPackage rec {
    pname = "kc";
    version = "1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "aslilac";
      repo = "kc";
      rev = "6e6e0813d9f2ed6c12b69112bc0fea69def7d8a2";
      hash = "sha256-JAPv8gshFlscVsnvglA4QaVSqf/76tMtrqrM/70Eu6g=";
    };

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.dbus ];

    doCheck = false;
    dontCargoInstallPostBuildHook = true;

    installPhase = ''
      mkdir -p $out/bin
      find . -name kc -type f -executable -exec cp {} $out/bin/kc \;
    '';
  };
in
{
  home.packages = [ kc ];
}
