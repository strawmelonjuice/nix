{ lib, pkgs, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd zox" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

  };
  # Forcing myself to evaluate all the options from https://home-manager-options.extranix.com/?query=programs.zsh.&release=release-25.11 and add them or ignore
  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "anatolykopyl/doas-zsh-plugin"; }
      ];
    };
    shellAliases = {
      # Stealing these back actually!
      to-dotfiles = "cd ~/.dotfiles || cd ~/dotfiles";
      rb = "to-dotfiles && jj file track . && doas nixos-rebuild switch --flake ~/.dotfiles#$(hostname)";

      ls = "eza --icons";
      la = "eza --icons -a";
      ll = "eza --icons -al";
      lt = "eza --icons -a --tree --level=1";
      v = "$EDITOR";
      cat = "bat -p";
      nano = "nvim";
      shutdown = "systemctl poweroff";
      ide = "zellij --layout ide";
      # JJ-related
      jje = "jj edit";
      jjd = "jj desc @";
      # jjd (in editor) and sign
      jjds = ''
        jj desc @ -m "


        Signed-off-by: $(git config user.name) <$(git config user.email)>" && jj desc @ && jj sign -r @
      '';
      jjda = ''jj describe @ -m "$(date)"'';
      jjs = "jj show";
      jjn = "jj next --edit";
      cargock = "cargo-clean-all --keep-days 21 ~ -i";

      # Zoxide + a little dash of info ------------------------------------------------
      cd = "zox";
      cdi = "zoxi";
    };
    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          hyfetch
          if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';
        zshConfig = lib.mkOrder 1000 ''
          # Completion styling ------------------------------------------------------------
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
          zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
        '';
        # more complex zsh functions n such go in here since i dont wanna deal with writing those without proper lsp <- Good idea of Ollie!
        zshConfigRest = lib.mkOrder 1100 (builtins.readFile ../../../configs/zshrc-append);
      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
        zshConfigRest
      ];
    enableCompletion = true;
    autocd = true;
    history = {
      ignoreSpace = true;
    };
  };
  home.packages = with pkgs; [
    shfmt
  ];
}
