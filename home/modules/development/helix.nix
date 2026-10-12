{
  config,
  inputs,
  pkgs,
  ...
}:
let
  theme = {
    fallback = "flatwhite";
    dark = "tokyonight_moon";
    # light = "flatwhite";
    light = "ingrid";
  };
in
{
  # Helix ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  programs.helix = {
    enable = true;
    package =
      # pkgs.steelix;
      inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      # theme = theme.fallback;
      inherit theme;

      editor.line-number = "relative";
      editor.mouse = true;
      editor.cursor-shape.insert = "bar";
      editor.cursor-shape.normal = "block";
      editor.cursor-shape.select = "block";
      editor.file-picker.hidden = false;
      editor.statusline = {
        left = [
          "mode"
          "file-name"
          "version-control"
        ];
        center = [ ];
        right = [
          "file-type"
          "position-percentage"
          "position"
        ];
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };
      keys.normal = {
        "C-s" = ":write";
      };
      keys.normal.C-space = {
        l = ":theme ${theme.light}";
        d = ":theme ${theme.dark}";
      };
      keys.insert = {
        "C-s" = [
          ":write"
          "normal_mode"
        ];
        down = [
          "move_visual_line_down"
          "normal_mode"
        ];
        up = [
          "move_visual_line_up"
          "normal_mode"
        ];
      };
    };
  };
  # Broken Steelix helix below.
  xdg.configFile."helix/helix.scm".text = ''
    (require "helix/editor.scm")
    (require (prefix-in helix. "helix/commands.scm"))
    (require (prefix-in helix.static. "helix/static.scm"))

    (provide shell open-helix-scm open-init-scm)

    (define (current-path)
    (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (editor-document->path focus-doc-id)))

    ;;@doc
    ;; Specialized shell implementation, where % is a wildcard for the current file
    (define (shell . args)
    (helix.run-shell-command
    (string-join
      ;; Replace the % with the current file
      (map (lambda (x) (if (equal? x "%") (current-path) x)) args)
      " ")))

    ;;@doc
    ;; Open the helix.scm file
    (define (open-helix-scm)
    (helix.open (helix.static.get-helix-scm-path)))

    ;;@doc
    ;; Opens the init.scm file
    (define (open-init-scm)
    (helix.open (helix.static.get-init-scm-path)))
  '';
  xdg.configFile."helix/init.scm".text = ''
    (require (prefix-in helix. "helix/commands.scm"))
    (require (prefix-in helix.static. "helix/static.scm"))
    (require (prefix-in helix. "helix/commands.scm"))

    (define colourscheme-light "${theme.light}") 
    (define colourscheme-dark "${theme.dark}")

    (define (is-dark? hour)
    (or (< hour 6) (>= hour 19)))

    (define (get-current-hour)
    (trim (value->string (command "date" '("+%H")))))

    (define (apply-auto-theme)
    (let* ([hour (get-current-hour)]
     [theme-to-use (if (is-dark? hour) colourscheme-dark colourscheme-light)])
    (helix.theme theme-to-use)))

    (apply-auto-theme)

    (define (switch-theme-light)
    (helix.theme colourscheme-light))

    (define (switch-theme-dark)
    (helix.theme colourscheme-dark))

    (provide switch-theme-light switch-theme-dark apply-auto-theme)
  '';
}
