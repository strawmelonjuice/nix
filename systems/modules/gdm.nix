{ ... }: {
  services.displayManager.gdm = {
    enable = true;
    autoSuspend = true;
  };
}
