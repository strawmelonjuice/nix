{ lib, pkgs, ... }:
{
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
        { name = "giacomocavalieri/zsh_gleam_completions"; }
      ];
    };

    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          # Have to have ssh-agent running now for yubikey sk-ed25519
          eval $(ssh-agent)
          ssh-add ~/.ssh/id_ed25519_sk_rk_ssh_strawmelonjuice_main ~/.ssh/id_ed25519_sk_rk_ssh_strawmelonjuice_sign
          clear
          ${pkgs.hyfetch}/bin/hyfetch
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
}
