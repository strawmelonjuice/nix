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
    fluffychat
    telegram-desktop
    signal-desktop
  ];
}
