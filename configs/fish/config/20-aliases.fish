# -----------------------------------------------------
# Aliases
# -----------------------------------------------------

# General aliases
alias c clear
alias cls clear
alias nf hyfetch
alias pf hyfetch
alias hf hyfetch

alias ff fastfetch
alias ls 'eza --icons'
alias la 'eza -a --icons'
alias ll 'eza -al --icons'
alias lt 'eza -a --tree --level=1 --icons'
alias shutdown 'systemctl poweroff'
alias v '$EDITOR'
alias bat 'bat --ignored-suffix .tmpl'
alias cat 'bat -p'
alias wifi nmtui
alias zed 'ZED_ALLOW_EMULATED_GPU=1 SHELL=$(which fish) zeditor'

# Update grub alias
alias update-grub 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

alias to-dotfiles "cd ~/.dotfiles || cd ~/dotfiles"

# Rebuild nix config
alias rb 'to-dotfiles && jj status && doas env PATH=$PATH nixos-rebuild switch --flake .#(hostname)'

# Zellij aliases and completion
# zellij setup --generate-completion fish | source
alias ide 'zellij --layout ide'
# IDE but without the editor.
alias id-e 'zellij --layout id-e'
alias strider 'zellij plugin --in-place -- zellij:strider'

# Cargo-related aliases
alias cargock 'cargo-clean-all --keep-days 21 ~ -i'

# JJ-related aliases
alias jje 'jj edit'
alias jjd 'jj describe @'
alias jjs 'jj show'
alias jjn 'jj next --edit'

# -----------------------------------------------------
# Directory navigation and aliases
# -----------------------------------------------------
zoxide init fish --cmd zox | source

function zap
    if test -d .jj; or test -d .git
        clear -x
        set -l repo_type ""
        if test -d .git -a -d .jj
            set repo_type "JJ (git-colocated)"
        else if test -d .jj
            set repo_type Jujutsu
        else
            set repo_type Git
        end

        echo "📂 Opened $repo_type repository: $(pwd)"

        if test -d .git
            git fetch
        else
            jj git fetch
        end
        # Show repository line counts
        kc

        if test -d .jj
            jj log -Tbuiltin_log_compact_full_description -r'ancestors(bookmarks() & @-, 5) & ~@' --reversed --no-pager --limit 5
            jj show --summary
        else
            git status
        end

        # Show repository filetree
        # eza --icons -L 2 -R --tree --git-ignore # Disabled. Output gets too long.

        # Dynamically tell user of flakes.
        if test -f flake.nix; and type -q nix; and not set -q IN_NIX_SHELL; and not test -f .envrc
            echo -e "\n\n❄️\tFound flake.nix, run 'create-envrc' to create a .envrc file here to load this flake automatically."
            echo -e "\tOr alternatively, run 'dev' to open Fish in a nix develop shell."
        end
    else
        eza -a --icons
    end
end

function dev
    if set -q IN_NIX_SHELL
        echo "⚠️  Already inside Nix shell!"
        return 0
    end
    if test -f .envrc
        echo "⚠️  .envrc found, direnv will be used."
        direnv allow
        return 0
    end
    if test -f flake.nix; and type -q nix
        nix develop --set-env-var SHELL $SHELL -c $SHELL
    else if not type -q nix
        echo "󱄅  Nix is not installed!"
    else
        echo "❌ No Flake.nix file in this directory"
    end
end

function create-envrc
    if test -f .envrc
        echo "⚠️  .envrc already here, can't safely insert."
        return 0
    end
    if test -f flake.nix; and type -q nix and
        type -q direnv
        if not test -f .gitignore; or not grep -q "^\.direnv/" .gitignore
            echo -e "\n# Ignore direnv cache\n.direnv/" >>.gitignore
        end
        echo "if nix flake show &> /dev/null; then
          use flake
        fi" >./.envrc
        direnv allow
    else if not type -q direnv
        echo "󱄅  Direnv is not installed!"
    else if not type -q nix
        echo "󱄅  Nix is not installed!"
    else
        echo "❌ No Flake.nix file in this directory"
    end
end

# Wrap functionality around zoxide's (bang)
function banger
    zox $argv; and zap
end

function bangeri
    zoxi $argv; and zap
end

alias cd banger
alias cdi bangeri
