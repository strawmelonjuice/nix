{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gnupg
  ];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
