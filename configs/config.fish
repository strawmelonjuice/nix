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
            # rad sync
	    git fetch rad
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
        echo "-> nixos-rebuild switch --flake \"$HOME/.dotfiles#"(hostname)"\""
        doas nixos-rebuild switch --flake "path:$HOME/.dotfiles#"(hostname)
    else
        echo "-> home-manager switch --flake \"$HOME/.dotfiles#"(hostname)"\""
        nix run home-manager -- switch --flake "path:$HOME/.dotfiles#"(hostname)
    end
end

function rad-init-cubchoo
	set -l rid (rad inspect --rid)
	echo "Seeding local repository $rid from Cubchoo"
	ssh root@cubchoo rad-system seed $rid
	ssh mar@cubchoo "cd /home/mar/files/projects/repos/radicle/ ; rad clone $rid"
end


function rad-proxied-clone
	rad seed $argv[1] --no-fetch
	rad sync --fetch $argv[1]

	set -l r_identity (rad inspect $argv[1] --identity)
	set -l r_name (echo $r_identity | jq '.payload.["xyz.radicle.project"].name' -j)
	set -l r_delegates (echo $r_identity | jq '.delegates')
	set -l p_did (ssh mar@cubchoo rad self --did)
	if not contains $p_did $r_delegates
        	echo "WARN: $p_did is not a delegate on $argv[1]!"
    	end
	set -l r_id (echo $argv[1] | sed 's,rad:,,')

	ssh mar@cubchoo "mkdir -p /cubchoo/radicle-proxied"
	ssh mar@cubchoo "rad clone $argv[1] --bare /cubchoo/radicle-proxied/$r_id/$r_name.git"
	scp /home/mar/.local/scripts/rad-proxy-git-hook.sh cubchoo:/cubchoo/radicle-proxied/$r_id/$r_name.git/hooks/post-receive
	ssh mar@cubchoo chmod +x /cubchoo/radicle-proxied/$r_id/$r_name.git/hooks/post-receive

	git clone cubchoo:/cubchoo/radicle-proxied/$r_id/$r_name.git $argv[2..9]
end

function rad-mirror-cubchoo
    set -l oldpwd (pwd)
    set -l da_tempi (mktemp)
    mkdir -p /home/mar/files/projects/repos/radicle
    cd /home/mar/files/projects/repos/radicle

    rad ls | grep "rad:" | sed "s/\(.*\)rad:\(.*\)   public\(.*\)/rad:\2/" > "$da_tempi"
    while read -l p
        echo "Asking Cubchoo to seed $p"
        ssh root@cubchoo rad-system seed $p 
    end < "$da_tempi"

    ssh root@cubchoo -- rad-system ls | grep "rad:" | sed "s/\(.*\)rad:\(.*\)   public\(.*\)/rad:\2/" > "$da_tempi"
    while read -l p
        echo "Cloning $p to local"
        rad clone $p; or echo "May have already existed."
        rad seed $p
    end < "$da_tempi"

    cd "$oldpwd"
end


# function rad-add-all-as-delegates
#     set -l da_tempi (mktemp)
#     # Get all hostname-based preferred seeds, which are in this case, all mine.
#     begin
#         echo ""
#         rad config get preferredSeeds
#         echo ""
#     end | grep -v "\." | sed "s,\(.*\)@\(.*\),\\1," | string join ' ' | sed "s/ z/ --delegate=did:key:z/g" > "$da_tempi"
#
#     rad id update (cat "$da_tempi") --description="Add the strawmelonjuice.- devices"
# end
