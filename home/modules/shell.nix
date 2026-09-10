{ pkgs, ... }:

let
  kc = pkgs.rustPlatform.buildRustPackage rec {
    pname = "kc";
    version = "1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "aslilac";
      repo = "kc";
      rev = "6e6e0813d9f2ed6c12b69112bc0fea69def7d8a2";
      hash = "sha256-JAPv8gshFlscVsnvglA4QaVSqf/76tMtrqrM/70Eu6g=";
    };

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.dbus ];

    doCheck = false;
    dontCargoInstallPostBuildHook = true;

    installPhase = ''
      mkdir -p $out/bin
      find . -name kc -type f -executable -exec cp {} $out/bin/kc \;
    '';
  };
in
{
  home.sessionVariables.SHELL = "fish";

  imports = [
    # ./shell/zsh.nix
    ./shell/fish.nix
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    options = [ "--cmd zox" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  # Direnv stuff
  programs.direnv = {
    silent = true;
    enable = true;
    nix-direnv = {
      enable = true;
    };
    # Direnv instant should have me here:
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
  };

  programs.direnv-instant = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transbian";
      mode = "rgb";
      light_dark = "light";
      lightness = 1.0;
      color_align = {
        mode = "horizontal";
      };
      backend = "macchina";
      pride_month_disable = false;
    };

  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  xdg.configFile."zellij" = {
    source = ../../configs/zellij;
    recursive = true;
  };

  xdg.configFile."starship.toml" = {
    source = ../../configs/starship.toml;
  };

  home.shellAliases = {
    to-dotfiles = "cd ~/.dotfiles || cd ~/dotfiles";
    urb = "rad sync rad:zF4ocfML4MryiqMDDX77R5HSKspr && jj --repository $HOME/.dotfiles git fetch --all-remotes && jj --repository $HOME/.dotfiles rebase --onto 'trunk()' && rb";
    hmrb = ''jj --repository "$HOME/.dotfiles" file track "$HOME/.dotfiles/."; nix run home-manager -- switch --flake "$HOME/.dotfiles#$(hostname)"'';

    ls = "eza --icons always ";
    la = "eza --icons always -a";
    ll = "eza --icons always -al";
    lt = "eza --icons always -a --tree --level=1";
    v = "$EDITOR";
    cat = "bat -p";
    nano = "nvim";
    shutdown = "systemctl poweroff";
    ide = "zellij --layout ide";
    rsamurott = "ssh Samurott niri output DP-1 mode 1920x1080@60; moonlight --1080 stream Samurott Desktop";
    # JJ-related
    jje = "jj edit";
    jjd = "jj desc @";
    jjda = ''jj describe @ -m "$(date)"'';
    jjs = "jj show";
    jjn = "jj next --edit";
    cargock = "cargo-clean-all --keep-days 21 ~ -i";

    # Zoxide + a little dash of info ------------------------------------------------
    cd = "zox";
    cdi = "zoxi";

  };

  home.packages = with pkgs; [
    shfmt
    eza
    bat
    zoxide
    starship
    hyfetch
    macchina
    zellij
    fzf
    xsel
    jq
    kc
  ];
}
