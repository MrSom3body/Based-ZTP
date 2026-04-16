{
  flake.modules.nixos.desktop = {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    programs.firefox.enable = true;
  };
}
