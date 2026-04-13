{ pkgs, ... }:
{
  flake.modules.nixos.desktop = {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = [ pkgs.thunderbird ];
  };
}
