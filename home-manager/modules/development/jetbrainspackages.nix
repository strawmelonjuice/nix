{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Missing dependencies when nix handles things, don't ask me why :sob:
    # Letting it do allat itself then
    jetbrains-toolbox
  ];
}
