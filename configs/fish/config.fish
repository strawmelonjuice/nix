# -----------------------------------------------------
# Fish Configuration
# -----------------------------------------------------

# This file is created once, you can edit here and it won't be in conflict with chezmoi

set fish_greeting ""
# Load modular Fish configuration files
for file in ~/.config/fish/config/*.fish
    if test -f $file
        source $file
    end
end
