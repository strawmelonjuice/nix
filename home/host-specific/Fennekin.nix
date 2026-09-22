{
  inputs,
  ...
}:
{
  imports = [
    ../modules/gnome.nix
    ../modules/touchscreen.nix
    ../modules/conversation.nix
    ../modules/entertainment/music-streaming.nix

    inputs.niri.homeModules.niri
  ];

  programs.niri.settings.outputs."Microstep MSI MP341CQ 0x00000316" = {
    variable-refresh-rate = "on-demand";
    mode = {
      width = 1920;
      height = 1080;
      refresh = 40.000;
    };
    scale = 1.1;
  };
}
