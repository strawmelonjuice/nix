# Set PATH
set -x PATH /usr/lib/ccache/bin /snap/bin $HOME/bin $HOME/.local/bin/mini $HOME/.bun/bin $PATH

# # Set history file location
# set -x fish_history "$HOME/.local/share/fish/fish_history"

# Set history size
set -x fish_history_size 10000

# -----------------------------------------------------
# INIT
# -----------------------------------------------------

# Exporting EDITOR
# On Debian, add nvim to path
if test -f /etc/debian_version
    set -x PATH $PATH /opt/nvim-linux64/bin
end
set -x USERTERM $TERM
if test -n "$WSL_INTEROP"
    set -x USERTERM "$TERM-wsl"
end

# Heartbreaking: Mise no longer important as package manager in Nix-configs.
# mise activate fish | source


set -x EDITOR nvim
set -x VISUAL nvim
if set -q ZED_TERM
    set -x EDITOR zeditor
    set -x VISUAL zeditor
    set -x JJ_EDITOR 'zeditor --wait'
end
# # On local machines, excluding on Niri (it doesn't need Muxing) or inside toolbx (because it's going to stack)
# if status is-interactive; and not set -q TOOLBOX_NAME; and not set -q NIRI_SOCKET; and not set -q SSH_CONNECTION
#     set ZELLIJ_AUTO_EXIT true
#     eval (zellij setup --generate-auto-start fish | string collect)
# end

# On SSH connections, we want a slightly different approach.
if status is-interactive; and set -q SSH_CONNECTION
    set ZELLIJ_AUTO_ATTACH true
    set ZELLIJ_AUTO_EXIT true
    eval (zellij setup --generate-auto-start fish | string collect)
end

direnv hook fish | source
