{
  flake.modules.nixos.nixos =
    { pkgs, ... }:
    {
      users = {
        mutableUsers = true;
        users =
          let
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+0M/HSOoGHHrAtVhObOUjWQpR0pvHmhd7PhRJifP01 karun@promethea"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvNc7Y9BZhPt/bc/bjwN0K6a6wXEsAQ5XYCbizcuX6z benedikt@snowflake"
            ];
          in
          {
            hugo = {
              isNormalUser = true;
              description = "Hugo Boss";
              shell = pkgs.fish;
              initialPassword = "Cisco123!";
              extraGroups = [
                "wheel"
                "input"
              ];
              openssh.authorizedKeys.keys = keys;
            };

            root.openssh.authorizedKeys.keys = keys;
          };
      };
    };
}
