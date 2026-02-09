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

    # We gebruiken hier weer de automatische methode, die is het veiligst voor paden
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.dbus ];

    # Schakel de tests en de automatische post-build hooks van de maker uit
    doCheck = false;
    dontCargoInstallPostBuildHook = true;

    # Omdat de automatische installatie faalde door de scripts van de maker,
    # doen we alleen de kopieerslag zelf, maar op een 'luie' manier.
    installPhase = ''
      mkdir -p $out/bin
      find . -name kc -type f -executable -exec cp {} $out/bin/kc \;
    '';
  };
in
{
  home.packages = [ kc ];
}
