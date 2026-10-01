{ pkgs, ... }:

{
  home.packages = with pkgs; [
    teams-for-linux
    
    # In case I may need to run something scary.
    wineWow64Packages.stable
    winetricks

    # Writing stuff
    obsidian
    libreoffice-stable
    tinymist
    typstwriter
    typst

    # Using a Typst template themed after Fontys (https://typst.app/universe/package/unofficial-fhict-document-template)
    # but it uses Roboto.
    roboto
  ];
}
