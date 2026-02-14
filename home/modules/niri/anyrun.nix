{ pkgs, ... }:

{
  programs.anyrun = {
    enable = true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.2;
      };
      width = {
        fraction = 0.5;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        # "${pkgs.anyrun}/lib/libsymbols.so"
      ];
    };

    extraCss = /* css */ ''
      * {
        all: unset;
        font-family: Atkinson Hyperlegible Next;
        font-size: 1.3rem;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #match.activatable {
        border-radius: 16px;
        padding: 0.3rem 0.9rem;
        margin-top: 0.01rem;
      }

      #match.activatable:first-child {
        margin-top: 0.7rem;
      }

      #match.activatable:last-child {
        margin-bottom: 0.6rem;
      }

      #plugin:hover #match.activatable {
        border-radius: 10px;
        padding: 0.3rem;
        margin-top: 0.01rem;
        margin-bottom: 0;
      }

      #match:selected,
      #match:hover,
      #plugin:hover {
        background: #2e3131;
      }

      #entry {
        background: #f4cccc;
        border: 3px solid rgb(255,77,77);
        color: #000000;
        border-radius: 16px;
        margin: 0.5rem;
        padding: 0.3rem 1rem;
      }

      list > #plugin {
        border-radius: 16px;
        margin: 0 0.3rem;
      }

      list > #plugin:first-child {
        margin-top: 0.3rem;
      }

      list > #plugin:last-child {
        margin-bottom: 0.3rem;
      }

      list > #plugin:hover {
        padding: 0.6rem;
      }

      box#main {
        background: #fa8071;
        box-shadow:
          inset 0 0 0 1px #0b0f10,
          0 0 0 1px #0b0f10;
        border-radius: 24px;
        padding: 0.3rem;
      }
    '';

  };
}
