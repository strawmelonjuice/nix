{ pkgs, ... }: {
  # Most times I'll use these it'll be in school...
  home.packages = with pkgs; [
    jetbrains.rust-rover
    jetbrains.webstorm
    jetbrains.rider
    jetbrains.pycharm
    # May use this one specifically when Gleamin' with Parrot
    jetbrains.datagrip
  ];
}
