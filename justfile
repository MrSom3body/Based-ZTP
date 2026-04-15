[private]
default:
    @just --list

### nixos ###

[group("nixos")]
builder mode host *args:
    nixos-rebuild {{mode}} --flake .#{{host}} {{args}}

[group("nixos")]
remote-builder mode host ip *args:
    @just builder {{mode}} {{host}} --target-host "root@{{ip}}" {{args}}

[group("nixos")]
build host *args: (builder "build" host args)

[group("nixos")]
switch host ip *args: && (remote-builder "switch" host ip args)
