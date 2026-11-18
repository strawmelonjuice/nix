{
  # hostname,
  pkgs,
  hostname,
  inputs,
  ...
}:

{
  # home.file.".radicle/keys/radicle".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.ssh/id_ed25519-radicle";
  # home.file.".radicle/keys/radicle.pub".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.ssh/id_ed25519-radicle.pub";
  home.packages = [
    inputs.rad-portable.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  programs.radicle = {

    settings = {
      publicExplorer = "https://rad.strawmelonjuice.nl/nodes/$host/$rid$path";
      preferredSeeds = (import ../../../../other/radicle-nodes.nix).all;
      cli.hints = true;

      node = {
        alias = "strawmelonjuice.${hostname}";
        # alias = "strawmelonjuice";
        listen = [
          "[::]:8776"
        ];
        seedingPolicy = {
          default = "block";
        };
      };
    };
    enable = true;
  };
  systemd.user.services.radicle-node = {
    Service = {
      ExecStart = pkgs.writeShellScript "radicle-node-starter" ''
                ${pkgs.radicle-node}/bin/rad follow z6MkqWHpFf8SoFQxJQPRw4xvKYrXTcUkRTzaeFio352xwYiA
               	${pkgs.radicle-node}/bin/rad follow z6MktUaCwVFEbkaHwb8maW5FjPqfvTVpafgmSnxiN8y1NtU3
              	${pkgs.radicle-node}/bin/rad follow z6MkjEcgs2bLEYMQDDSrCjVxzcZens5D3vFz9AxhyHbSjSo9
              	${pkgs.radicle-node}/bin/rad follow z6MkozXoRQG2zosyFTGSmtxbxqj1y4sdBevhnsAQH6xbJQxz

        	${pkgs.radicle-node}/bin/rad node start --foreground
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

}
