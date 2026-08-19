{
  pkgs,
  config,
  ...
}:

{
  programs.radicle.enable = true;
  # Why does this attempt to override stuff the node sets itself...
  # services.radicle.node.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "MLC Bloeiman";
      user.email = "mar@strawmelonjuice.com";
      core.excludesfile = "${config.home.homeDirectory}/.config/jj/ignore";
    };
  };
  programs.jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      user.name = "MLC Bloeiman";
      user.email = "mar@strawmelonjuice.com";
      signing = {
        backend = "ssh"; # Or gpg, both r fine w me!
        behaviour = "own";
        key = "/home/mar/.ssh/id_ed25519.pub";
        gpg.key = "9FFA7AE8896DD236";
      };
      ui.diff-formatter = [
        "difft"
        "--color=always"
        "$left"
        "$right"
      ];
      ui = {
        editor = "${pkgs.neovim}/bin/nvim";
        streampager.wrapping = "none";
        movement.edit = true;
        default-command = "status";
        show-cryptographic-signatures = true;
      };
      revsets.bookmark-advance-to = "coalesce(@ & ~empty(), @-)";
      template-aliases.default_commit_description = ''
        	concat(
        		"feat:|fix:|refactor:|style:|test:|docs:|build:|perf:|chore:|test:|ops: [what?]",
        		"\n\n[tell me more? :3]\n\n",
        		"\nSigned-off-by: ",
        		self.author().name(),
        		" <", self.author().email(), ">\n",
        		"\nJJ: ignore-rest\n",
        		diff.git(),
        	)
      '';
      aliases = {
        # Always using the git backend to clone so why not.
        clone = [
          "git"
          "clone"
        ];

        # Fetch and rebase onto trunk
        tt = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          "jj git fetch && jj rebase --onto 'trunk()'"
        ];

        # Advance bookmark, then push it
        ap = [ "autopush" ];
        autopush = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          "jj bookmark advance && jj git push"
        ];

        # Describe a change, sign it and then create a new change on top
        ds = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          "jj describe && jj sign && jj new"
        ];

        # Bit more history
        log-more = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "-r"
          "all()"
          "-n30"
          "--reversed"
          "--no-pager"
        ];

        # A compact, reversed log view
        ll = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "--reversed"
          "--no-pager"
        ];

        # Rebases your active branches onto the main trunk
        up = [ "catchup" ];
        catchup = [
          "rebase"
          "-b"
          "bookmarks() & mine() & ~immutable()"
          "-d"
          "trunk()"
          "--skip-emptied"
        ];

        # Lists items with '[TODO]'
        todo-list = [
          "log"
          "-Tbuiltin_log_compact_full_description"
          "-r"
          "all() & description(substring:'[TODO]') & mine()"
          "-n30"
          "--reversed"
          "--no-pager"
        ];

        # Finds the latest '[TODO]' commit and edits it.
        todo-edit-latest = [
          "edit"
          "--ignore-immutable"
          "latest(description(substring:'[TODO]') & mine())"
        ];

        # Toggles '[TODO]' on current commit.
        todo-toggle = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          ''
            CURRENT_MSG=$(jj log -r @ -T 'description' --no-graph)
            if echo "$CURRENT_MSG" | grep -q "^\[TODO\]"; then
              # If it starts with [TODO], strip it and any trailing space
              NEW_MSG=$(echo "$CURRENT_MSG" | sed 's/^\[TODO\] *//')
            else
              # If it doesn't, add it
              NEW_MSG="[TODO] $CURRENT_MSG"
            fi
            jj describe -m "$NEW_MSG"
          ''
        ];

      };
    };
  };
  xdg.configFile."jj/ignore".text = ''
    # Environment variables
    .env
    .envrc
    # direnv cache.
    .direnv
    # Editor configs
    .vscode
    .idea
  '';

  home.packages = with pkgs; [
    lazyjj
    lazygit
    git
    difftastic
  ];
}
