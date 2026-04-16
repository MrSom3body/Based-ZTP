{
  flake.modules.nixos.checkmk-server = {
    imports = [ ./_compose.nix ];
    networking.firewall.allowedTCPPorts = [
      8080
      8000
    ];
  };
}
