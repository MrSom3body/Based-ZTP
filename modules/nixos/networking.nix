{
  flake.modules.nixos.nixos = {
    networking = {
      useNetworkd = true;
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };

      # nameservers = [
      #   "9.9.9.9#dns.quad9.net"
      #   "149.112.112.112#dns.quad9.net"
      #   "2620:fe::fe#dns.quad9.net"
      #   "2620:fe::9#dns.quad9.net"
      # ];
    };

    services = {
      # DNS resolver
      resolved = {
        enable = true;
        settings.Resolve = {
          DNSOverTLS = "true";
          DNSSEC = "true";
        };
      };
    };
  };
}
