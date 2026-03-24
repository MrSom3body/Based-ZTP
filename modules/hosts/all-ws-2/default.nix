{
  flake.modules.nixos."hosts/all-ws-2" = {
    networking = {
      interfaces = {
        "ens33".useDHCP = true;
      };
    };
  };
}
