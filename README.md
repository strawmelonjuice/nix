### 1. Clone the repo

Cloning the `nix` branch using `jj` from the Strawmelonjuice forge:

```bash
# Temporary pre-install these required packages
nix shell github:nixos/nixpkgs/nixos-unstable#jujutsu --extra-experimental-features nix-command --extra-experimental-features flakes
nix shell github:nixos/nixpkgs/nixos-unstable#git --extra-experimental-features nix-command --extra-experimental-features flakes

# Clone the dotfiles
jj git clone https://forge.strawmelonjuice.com/strawmelonjuice/nix.git -b main --no-colocate ~/.dotfiles

cd ~/.dotfiles
# Set origin correctly for dotfiles
jj git remote set-url origin ssh://git@forge.strawmelonjuice.com/strawmelonjuice/nix.git

# Clone wallpapers.
git clone https://github.com/D3Ext/aesthetic-wallpapers.git ~/.local/share/wallpapers/aesthetic-wallpapers
```

2. Initialize a new Host
   If this is a brand new device (e.g., `workstation`):

Create the folder: `mkdir -p hosts/workstation` (`mkdir -p hosts/$(hostname)`)

Copy the installer configs: `cp /etc/nixos/*.nix ./hosts/workstation/` (`cp /etc/nixos/*.nix ./hosts/$(hostname)/`)

Update flake.nix: Include the new hostname in the nixosConfigurations block.

3. Deploy
   Nix uses your system's hostname to determine which configuration to apply.

```Bash

# Track new files so the flake can see them
jj
# Apply based on current hostname
sudo nixos-rebuild switch --flake .#$(hostname)
# Now you won't have sudo anymore, so make sure doas works!
doas git config --global --add safe.directory /home/mar/.dotfiles
```

## Structure

| Directory   | For                                                                                                  |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| `hosts/*`   | Device-specific hardware and system settings (e.g., Fennekin's convertible tweaks).                  |
| `home/*`    | Shared user environment and config                                                                   |
| `configs/*` | Configuration files symlinked into their programs for when configuration is too advanced for `home/` |
| `fonts/*`   | Fonts, imported by `home/modules/fonts.nix`                                                          |
| `libs` | Bad habits. Libraries unavailable on nixpkgs and I was apparently too lazy to make an input out of them. |

## Hosts currently known

| Name     | Kind               | About                                                     | Special                                                                       |
| -------- | ------------------ | --------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Fennekin | Convertible laptop | My take-with-me and drawing laptop, has a nice stylus tew | Touchscreen, convertible, wifi adaptor is busted, so there's an external one. |
| Ponyta | Laptop | My most beefiest laptop eva! And I use it mainly as my school laptop. | Has a good graphics card. Bigger screen. |
| samurott-nix | Virtual Machine; Desktop PC | - | Ultrawide screen. |
