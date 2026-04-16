{
  flake.modules.nixos.checkmk-server = {
    podman.composeProjects = {
      checkmk-server = ./.;
    };
  };
}
