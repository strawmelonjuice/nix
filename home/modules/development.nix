{ pkgs, ... }:

{
  imports = [
    ./development/jujutsu.nix
    ./development/neovim.nix
    ./development/zed.nix
    ./development/vscodium.nix
  ];
  programs.mise = {
    enable = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  home.packages = with pkgs; [
    # Mise is being faded out in favor of just due to growing friction between me and Mise's style
    # just # Hope I get away with this, having flakes and all.
    just-lsp
    # I make a lot of things with Inkscape actually!
    inkscape
  ];
}
