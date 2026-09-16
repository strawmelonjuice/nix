{
  # hostname,
  pkgs,
  config,
  ...
}:

{
  home.file.".radicle/keys/radicle".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.ssh/id_ed25519-radicle";
  home.file.".radicle/keys/radicle.pub".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.ssh/id_ed25519-radicle.pub";

  programs.radicle = {

    settings = {
      publicExplorer = "https://rad.strawmelonjuice.nl/nodes/$host/$rid$path";
      preferredSeeds = [
        # Mine
        "z6MkfJTnV1rGvGaykrPQzLMSQN7zB2bB7nNuYZyPL5QrdDB7@seed.strawmelonjuice.nl:8776"
        "z6MkfJTnV1rGvGaykrPQzLMSQN7zB2bB7nNuYZyPL5QrdDB7@samurott:8776"
        "z6MkfJTnV1rGvGaykrPQzLMSQN7zB2bB7nNuYZyPL5QrdDB7@ponyta:8776"
        "z6MkfJTnV1rGvGaykrPQzLMSQN7zB2bB7nNuYZyPL5QrdDB7@fennekin:8776"
        "z6MkfJTnV1rGvGaykrPQzLMSQN7zB2bB7nNuYZyPL5QrdDB7@cubchoo:8778"

        # Mine (old, with each a key)
        "z6MkqWHpFf8SoFQxJQPRw4xvKYrXTcUkRTzaeFio352xwYiA@samurott:8776"
        "z6MkjEcgs2bLEYMQDDSrCjVxzcZens5D3vFz9AxhyHbSjSo9@fennekin:8776"
        "z6MkozXoRQG2zosyFTGSmtxbxqj1y4sdBevhnsAQH6xbJQxz@ponyta:8776"

        # Defaultish
        "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@iris.radicle.network:8776"
        "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@irisradizskwweumpydlj4oammoshkxxjur3ztcmo7cou5emc6s5lfid.onion:8776"
        "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosa.radicle.network:8776"
        "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosarad5bxgdlgjnzzjygnsxrwxmoaj4vn7xinlstwglxvyt64jlnhyd.onion:8776"
      ];

      cli.hints = true;

      node = {
        # alias = "strawmelonjuice.${hostname}";
        alias = "strawmelonjuice";
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
