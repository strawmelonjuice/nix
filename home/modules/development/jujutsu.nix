{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "MLC Bloeiman";
      user.email = "mar@strawmelonjuice.com";
    };
  };
  programs.jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user.name = "MLC Bloeiman";
      user.email = "mar@strawmelonjuice.com";
      ui.diff-formatter = [
        "difft"
        "--color=always"
        "$left"
        "$right"
      ];
      ui.editor = "nvim";
      ui.streampager.wrapping = "none";
      ui.default-command = "status";
      aliases = {
        # Moves bookmarks from the previous commit to your current one
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "coalesce(@ & ~empty(), @-)"
        ];

        # A compact, reversed log view
        ll = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "--reversed"
          "--no-pager"
        ];

        # Rebases your active branches onto the main trunk
        catchup = [
          "rebase"
          "-b"
          "bookmarks() & mine() & ~immutable()"
          "-d"
          "trunk()"
          "--skip-emptied"
        ];
      };
    };

  };

  home.packages = with pkgs; [
    lazyjj
    lazygit
    git
    difftastic
  ];
}
