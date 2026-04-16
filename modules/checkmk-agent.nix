{
  flake.modules.nixos.checkmk-agent =
    { pkgs, ... }:
    let
      checkmkAgent = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Checkmk/checkmk/master/agents/check_mk_agent.linux";
        sha256 = "sha256-bi6SmoRoeva7zHiuXVVG/bOIuYd3y0R32MjtwhPqsDE=";
      };
    in
    {
      environment.systemPackages = with pkgs; [ socat ];

      users.users.checkmk = {
        isSystemUser = true;
        group = "checkmk";
      };

      users.groups.checkmk = { };

      systemd.services.checkmk-agent = {
        description = "Checkmk Agent via socat";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            ${pkgs.socat}/bin/socat \
              TCP-LISTEN:6556,reuseaddr,fork \
              EXEC:${pkgs.runtimeShell}\ ${checkmkAgent},pty,stderr
          '';
          User = "root";
          Restart = "always";
          RestartSec = 2;
        };
      };
      networking.firewall.allowedTCPPorts = [ 6556 ];
    };
}
