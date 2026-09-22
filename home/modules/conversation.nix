{ pkgs, ... }:

{
  programs = {
    vesktop = {
      enable = true;

      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        notifyAboutUpdates = true;

        plugins = {
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
        };
      };
    };
    element-desktop = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    # I'll still use Fluffy from the browser, but since it seems to want to break very much,
    # locally I'll have element...
    telegram-desktop
    signal-desktop
  ];
}
