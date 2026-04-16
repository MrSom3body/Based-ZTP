[private]
default:
    @just --list

### nixos ###

[group("install")]
install host ip user="junioradmin":
    nixos-anywhere --flake ".#{{host}}" --target-host "{{user}}@{{ip}}"

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

[group("nixos")]
test host ip *args: && (remote-builder "test" host ip args)

[group("nixos")]
test-all:
    @just test omega 10.40.21.60
    @just test sigma 10.40.21.61
    @just test lambda 10.40.21.62
