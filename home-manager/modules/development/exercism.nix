{ pkgs, ... }: {
  home.packages = with pkgs; [
    exercism
    # fishPlugins.exercism-cli-fish-wrapper
  ];
}
