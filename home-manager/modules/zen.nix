{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    # Check these out at about:config
    "extensions.pocket.enabled" = false;
    "extensions.autoDisableScopes" = 0;
    "browser.startup.homepage" = "https://strawmelonjuice.com/startpage/";
    "zen.welcome-screen.seen" = true;
    "zen.view.use-single-toolbar" = true;
    "general.useragent.locale" = "en-GB";
    # Tried setting this to false to get my own startpage but alas.
    "zen.urlbar.replace-newtab" = true;
    "browser.newtabpage.pinned" =
      ''[{"title":"My home","url":"https://strawmelonjuice.com/startpage/"}]'';
    "browser.policies.runOncePerModification.removeSearchEngines" =
      ''["Google","Bing","Amazon.com","eBay","Twitter","Perplexity"]'';
  };

  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "heylogin" "firefox@heylogin.com")
    (extension "margin" "hello@margin.at")
    (extension "netflix-party-is-now-teleparty" "firefox@teleparty.com")
    (extension "excalisave" "excalisave@atharvakadlag.github.io")
    (extension "cat-gatekeeper" "neko-extension@example.com")
    (extension "pronoundb" "firefox-addon@pronoundb.org")
    # ...
  ];

in
{
  home.packages = [
    (pkgs.wrapFirefox
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
      {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (
            name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
          ) prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "ddgnoai";
            Add = [
              {
                Name = "DuckDuckGo (no AI)";
                URLTemplate = "https://noai.duckduckgo.com/search?q={searchTerms}";
                IconURL = "https://duckduckgo.com/favicon.ico";
                Alias = "ddgnoai";
              }
              {
                Name = "nixpkgs packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://wiki.nixos.org/favicon.ico";
                Alias = "nixpkgs";
              }
              {
                Name = "Searchix";
                URLTemplate = "https://search.nix.ee/?OptionSet=programs&query={searchTerms}";
                IconURL = "https://search.nix.ee/favicon.ico";
                Alias = "nx";
              }
              {
                Name = "noogle";
                URLTemplate = "https://noogle.dev/q?term={searchTerms}";
                IconURL = "https://noogle.dev/favicon.ico";
                Alias = "ng";
              }
            ];
          };
        };
      }
    )
  ];
}
