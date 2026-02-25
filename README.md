### 1. Clone the repo

Cloning the `nix` branch using `jj` from the Strawmelonjuice forge:

```bash
# Temporary pre-install these required packages
nix shell nixpkgs#git nixpkgs#jujutsu --extra-experimental-features nix-command --extra-experimental-features flakes

# Clone the dotfiles
jj git clone https://forge.strawmelonjuice.com/strawmelonjuice/nix.git -b main --no-colocate ~/.dotfiles

cd ~/.dotfiles
# Set origin correctly for dotfiles, assuming you by the time you push again have the keys.
jj git remote set-url origin ssh://git@forge.strawmelonjuice.com/strawmelonjuice/nix.git

# Clone wallpapers.
jj git clone https://github.com/D3Ext/aesthetic-wallpapers.git ~/.local/share/wallpapers/aesthetic-wallpapers
```

2. Initialize a new Host if this is a brand new device:
```bash
mkdir -p hosts/$(hostname) # Create the folder
cp /etc/nixos/*.nix ./hosts/$(hostname)/ # Copy installer configs
nano ./flake.nix # Include the new hostname in the nixosConfigurations block.
nano ./hosts/$(hostname)/configuration.nix # You may want to tweak this, or maybe import `../all-hosts.nix`!
```
Otherwise make sure the hostname matches the one before and continue to 3!

3. Deploy
```Bash
jj # Capture new files so the flake can see them
sudo nixos-rebuild switch --flake .#$(hostname) # Apply based on current hostname

# If you included all-hosts.nix, you now won't have sudo anymore, so make sure doas works!

doas git config --global --add safe.directory /home/mar/.dotfiles # Safelist dotfiles for root, so doas can be used to rebuild!
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
