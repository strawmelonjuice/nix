{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "middlemouse.paste" = false;
      "general.autoscroll" = true;
      "privacy.resistFingerprinting" = false;
      "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
    };
  };
}
