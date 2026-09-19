{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./vcs/radicle.nix
  ];
  programs.git = {
    enable = true;
    settings = {
      user.name = "MLC Bloeiman";
      user.email = "strawmelonjuice@proton.me";
      core.excludesfile = "${config.home.homeDirectory}/.config/jj/ignore";
    };
  };
  programs.jujutsu = {
    enable = true;
    package = pkgs.jujutsu;
    settings = {
      inherit (config.programs.git.settings) user;
      signing = {
        backend = "ssh"; # Or gpg, both r fine w me!
        behaviour = "own";
        key = "/home/mar/.ssh/id_ed25519.pub";
        gpg.key = "9FFA7AE8896DD236";
      };
      git = {
        write-change-id-header = true;
        sign-on-push = true;
      };
      ui = {
        diff-formatter = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];

        editor = "${pkgs.neovim}/bin/nvim";
        streampager.wrapping = "none";
        movement.edit = true;
        default-command = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          ''
            jj show --template builtin_log_oneline --stat
            jj bookmark list
          ''

        ];
        show-cryptographic-signatures = true;

      };
      revset-aliases = {
        "trunk()" = ''
          latest(

            remote_bookmarks(exact:"mistress", exact:"origin") |
            remote_bookmarks(exact:"main", exact:"origin") |
            remote_bookmarks(exact:"master", exact:"origin") |
            remote_bookmarks(exact:"trunk", exact:"origin") |

            remote_bookmarks(exact:"mistress", exact:"upstream") |
            remote_bookmarks(exact:"main", exact:"upstream") |
            remote_bookmarks(exact:"master", exact:"upstream") |
            remote_bookmarks(exact:"trunk", exact:"upstream") |

            remote_bookmarks(exact:"mistress", exact:"rad") |
            remote_bookmarks(exact:"main", exact:"rad") |
            remote_bookmarks(exact:"master", exact:"rad") |
            remote_bookmarks(exact:"trunk", exact:"rad") |

            root()
          )
        '';
        "immutable_heads()" = ''
          		present(trunk()) | tags() | ( 
           			untracked_remote_bookmarks() ~ 
           			untracked_remote_bookmarks(remote='rad') ~ 
           			untracked_remote_bookmarks(regex:'^patch(es)/',remote='rad')
           		)'';
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

        push = [
          "git"
          "push"
        ];

        bookmarks = [
          "bookmark"
          "list"
        ];

        advance = [
          "bookmark"
          "advance"
        ];

        # Fetch and rebase onto trunk
        tt = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          "jj git fetch --all-remotes && jj rebase --onto 'trunk()'"
        ];

        open = [
          "new"
          "trunk()"
        ];

        rad-sync = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          "rad sync && jj git fetch rad"
        ];

        rad-patch = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
                    set -euo pipefail
            	    REV="$(jj show -T 'commit_id' --no-patch -r @)"
            	    git push rad "$REV:refs/patches"
          ''
        ];

        rad-setup-sign = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"

          ''
            jj config set --workspace signing.key "$(rad self --ssh-key)"
          ''
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
