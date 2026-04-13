{
  flake.modules.nixos.desktop = {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    programs.thunderbird.enable = true;
  };
}
