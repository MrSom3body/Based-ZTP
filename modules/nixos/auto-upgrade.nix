{
  flake.modules.nixos.nixos = {
    system.autoUpgrade = {
      enable = true;
      flake = "github:MrSom3body/Based-ZTP";

      dates = "04:40";
      persistent = true;

      allowReboot = true;
      rebootWindow = {
        lower = "01:00";
        upper = "05:00";
      };

      runGarbageCollection = true;
    };
  };
}
