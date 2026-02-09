{ pkgs, ... }:

{
  # Zorgt dat applicaties de fonts in je home-profile kunnen vinden
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    font-awesome

    (runCommand "lotion-fonts" { } ''
      mkdir -p $out/share/fonts/truetype/lotion
      # We kopiëren alle fonts uit je legacy-dotfiles map naar de Nix store
      cp -r ${../../fonts}/Lotion*.ttf $out/share/fonts/truetype/lotion/
    '')
  ];
}
