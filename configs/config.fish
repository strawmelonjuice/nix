set -gx EDITOR nvim

# Function: zap
function _zap
    if test -d .jj -o -d .git
        clear -x
        set -l repo_type ""

        if test -d .git -a -d .jj
            set repo_type "JJ (git-colocated)"
        else if test -d .jj
            set repo_type "Jujutsu"
        else
            set repo_type "Git"
        end

        echo "📂 Opened $repo_type repository: "(pwd)

        if type -q rad
            rad sync
        end

        if test -d .git
            git fetch --all
        else
            jj git fetch --tracked --all-remotes
        end

        kc

        if test -d .jj
            jj log -Tbuiltin_log_compact_full_description -r'ancestors(bookmarks() & @-, 5) & ~@' --reversed --no-pager --limit 5
            jj show --summary
        else
            git status
        end

        # Dynamically tell user of flakes.
        if test -f flake.nix; and type -q nix; and test -z "$IN_NIX_SHELL"; and not test -f .envrc
            echo -e "\n\n❄\tFound flake.nix, run 'create-envrc' to create a .envrc file here to load this flake automatically."
        end
        eza -a --icons
    else
        eza -a --icons
    end
end

function _zap_on_cd --on-variable PWD
    # Check if stdout is an interactive terminal
    if status is-interactive
        _zap
    end
end

# Function: create-envrc
function create-envrc
    if test -e .envrc
        echo "⚠  .envrc already here, can't safely insert."
        direnv reload
        return 0
    end

    if not type -q nix
        echo "󱄅  Nix is not installed!"
        return 1
    end

    if not type -q direnv
        echo "󱄅  Direnv is not installed!"
        return 1
    end

    if test -e flake.nix
        printf 'if nix flake show &> /dev/null; then\n\tuse flake\nfi\n' > ./.envrc
    else if test -e default.nix -o -e shell.nix
        printf 'if [ -e shell.nix -o -e default.nix ]; then\n\tuse nix\nfi\n' > ./.envrc
    else
        echo "❌ No usable nix file in this directory"
        return 1
    end

    if not test -e .gitignore; or not grep -q "^\.direnv/" .gitignore
        echo "💨 Adding direnv cache to gitignore"
        echo -e "\n# Ignore direnv cache\n.direnv/" >> .gitignore
        direnv allow
    else
        direnv allow
    end
end

function rb
    jj --repository "$HOME/.dotfiles" file track "$HOME/.dotfiles/."

    if test -f /etc/NIXOS
        echo "-> nixos rebuild switch --flake \"$HOME/.dotfiles#"(hostname)"\""
        doas nixos-rebuild switch --flake "$HOME/.dotfiles#"(hostname)
    else
        echo "-> home-manager switch --flake \"$HOME/.dotfiles#"(hostname)"\""
        nix run home-manager -- switch --flake "$HOME/.dotfiles#"(hostname)
    end
end

function rad-mirror-cubchoo
    set -l oldpwd (pwd)
    set -l da_tempi (mktemp)
    mkdir -p /home/mar/files/projects/repos/radicle
    cd /home/mar/files/projects/repos/radicle

    rad ls | grep "rad:" | sed "s/\(.*\)rad:\(.*\)   public\(.*\)/rad:\2/" > "$da_tempi"
    while read -l p
        echo "Asking Cubchoo to seed $p"
        ssh cubchoo rad seed $p --scope=all
    end < "$da_tempi"

    ssh cubchoo -- rad ls | grep "rad:" | sed "s/\(.*\)rad:\(.*\)   public\(.*\)/rad:\2/" > "$da_tempi"
    while read -l p
        echo "Cloning $p to local"
        rad clone $p --scope=all; or echo "May have already existed."
        rad seed $p --scope=all
    end < "$da_tempi"

    cd "$oldpwd"
end

function rad-add-all-as-delegates
    set -l da_tempi (mktemp)
    # Get all hostname-based preferred seeds, which are in this case, all mine.
    begin
        echo ""
        rad config get preferredSeeds
        echo ""
    end | grep -v "\." | sed "s,\(.*\)@\(.*\),\\1," | string join ' ' | sed "s/ z/ --delegate=did:key:z/g" > "$da_tempi"

    rad id update (cat "$da_tempi") --description="Add the strawmelonjuice.- devices"
end
