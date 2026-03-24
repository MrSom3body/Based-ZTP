{
  flake.modules.nixos."hosts/all-ws-1" = {
    networking = {
      interfaces = {
        "ens33".useDHCP = true;
      };
    };
  };
}
