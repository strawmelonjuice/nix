I mainly keep this readme for myself, but if you're trying to adopt my dotfiles and stuck somewhere, contact me! You should be able to find my details on <https://strawmelonjuice.com/me/links>.

### 1. Clone the repo

Cloning the `nix` branch using `jj` from my Tangled knot:

```bash
# Temporary pre-install these required packages
nix shell nixpkgs#git nixpkgs#jujutsu --extra-experimental-features nix-command --extra-experimental-features flakes

# Clone the dotfiles
jj git clone https://tangled.org/did:plc:jgtfsmv25thfs4zmydtbccnn/nix -b main ~/.dotfiles

cd ~/.dotfiles
# Set origin correctly for dotfiles, assuming you by the time you push again have the keys.
jj git remote set-url origin git@knot.strawmelonjuice.com:did:plc:jgtfsmv25thfs4zmydtbccnn/nix
# Clone wallpapers.
jj git clone https://github.com/D3Ext/aesthetic-wallpapers.git ~/.local/share/wallpapers/aesthetic-wallpapers
```

### 2. Initialize a new Host (optional, if this is a brand new device)

```bash
mkdir -p hosts/$(hostname) # Create the folder
cp /etc/nixos/*.nix ./hosts/$(hostname)/ # Copy installer configs
nano ./flake.nix # Include the new defineSystem/defineHome-entry in the nixosConfigurations block.
nano ./hosts/$(hostname)/configuration.nix # You may want to tweak this, or maybe import `../all-hosts.nix`!
echo "{}" > ./home/host-specific/$(hostname).nix # For home-manager per-machine config
```

Otherwise make sure the hostname matches the one before and continue to 3!

If it is a new device, but not running NixOS, you'll have to only create the `defineHome` and home-manager-per-machine config.

### 3. Deploy

#### For NixOS
```Bash
jj # Capture new files so the flake can see them
sudo nixos-rebuild switch --flake .#$(hostname) # Apply based on current hostname

# If you included all-hosts.nix, you now won't have sudo anymore, so make sure doas works!

doas git config --global --add safe.directory /home/mar/.dotfiles # Safelist dotfiles for root, so doas can be used to rebuild!
```


#### For Home Manager Standalone (Non-NixOS or User-only)
```Bash
jj # Capture new files
nix run home-manager -- switch --flake .#$(hostname)
```



## Structure

| Directory   | For                                                                                                  |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| `hosts/*`   | Device-specific hardware and system settings (e.g., Fennekin's convertible tweaks).                  |
| `home/*`    | Shared user environment and config                                                                   |
| `configs/*` | Configuration files symlinked into their programs for when configuration is too advanced for `home/` |
| `fonts/*`   | Fonts, imported by `home/modules/fonts.nix`                                                          |

## Hosts currently known

| Name     | Kind               | About                                                                 | Special                                                                       |
| -------- | ------------------ | --------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [Fennekin](https://pokemondb.net/pokedex/fennekin) | Convertible laptop (fire) | My take-with-me and drawing laptop, has a nice stylus tew             | Touchscreen, convertible, wifi adaptor is busted, so there's an external one. |
| [Ponyta](https://pokemondb.net/pokedex/ponyta)   | Laptop (fire)            | My most beefiest laptop eva! And I use it mainly as my school laptop. | Has a good graphics card. Bigger screen.                                      |
| [Samurott](https://pokemondb.net/pokedex/samurott) | Desktop PC (water)         | -                                                                     | Ultrawide screen, dual boots windows for games.                               |
| [Cubchoo](https://pokemondb.net/pokedex/cubchoo) | Server (ice) | Also known as `marpi5-1` or `strawmelonservices`! | Lives in a hamster cage |
| [frigometri (german version of Cryogonal, symbolising server location)](https://pokemondb.net/pokedex/cryogonal) | Server (ice) | Cool server from friend I can use |
