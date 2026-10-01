{ pkgs, ... }:

let
  frankmoji = pkgs.stdenv.mkDerivation {
    pname = "frankmoji";
    version = "0.0.12-beta";

    src = pkgs.fetchurl {
      url = "https://frankmoji.com/download/FrankMojiBeta0012-Font.zip";
      sha256 = "sha256-28Ji/IRQG0mh4ZoM5v+EiipcJNgulhILf3HASV3VvWA=";
    };

    nativeBuildInputs = [ pkgs.unzip ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      install -Dm644 FrankMojiBeta0012_COLRv1.ttf $out/share/fonts/truetype/FrankMojiBeta0012_COLRv1.ttf
      install -Dm644 FrankMojiBeta0012_COLRv1.woff2 $out/share/fonts/woff2/FrankMojiBeta0012_COLRv1.woff2
      install -Dm644 LICENSE.txt $out/share/doc/frankmoji/LICENSE.txt

      runHook postInstall
    '';
  };
in
{
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    emoji = [ "FrankMojiBeta0012" "joypixels" ];
    monospace = [ "Maple Mono NF" "Lilex Nerd Font Mono" "Hermit" ];
  };

  home.packages = with pkgs; [
    frankmoji
    joypixels
    maple-mono.NF
    hermit
    nerd-fonts.lilex
    nerd-fonts.symbols-only
    font-awesome
  ];
}
